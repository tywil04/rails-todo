require "json"

class Webauthn::RegistrationsController < ApplicationController
    def challenge
        if !current_user.webauthn_id
            current_user.update(webauthn_id: WebAuthn.generate_user_id[0..63])
        end

        options = WebAuthn::Credential.options_for_create(
            user: {
                id: current_user.webauthn_id,
                name: current_user.email,
                display_name: current_user.name,
            },
            exclude: Credential.where(user: current_user).map { |c| c.webauthn_id }
        )

        session[:creation_challenge] = options.challenge;

        respond_to do |format|
            format.html { render "index" }
            format.json { render json: options }
        end
    end

    def verify
        publicKeyCredential = JSON.parse(params["publicKeyCredential"]);
        webauthn_credential = WebAuthn::Credential.from_create(publicKeyCredential);

        begin
            webauthn_credential.verify(session[:creation_challenge]);

            Credential.create(user: current_user, webauthn_id: webauthn_credential.id, public_key: webauthn_credential.public_key, sign_count: webauthn_credential.sign_count)
        rescue WebAuthn::Error => e
            puts e
        end
    end
end
