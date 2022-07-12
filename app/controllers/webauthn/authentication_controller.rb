class Webauthn::AuthenticationController < ApplicationController
    def challenge
        options = WebAuthn::Credential.options_for_get(allow: Credential.all.map { |c| c.webauthn_id });
        session[:authentication_challenge] = options.challenge;

        respond_to do |format|
            format.html { render "index" }
            format.json { render json: options }
        end
    end

    def verify
        publicKeyCredential = JSON.parse(params["publicKeyCredential"]);
        webauthn_credential = WebAuthn::Credential.from_get(publicKeyCredential);
        stored_credentials = Credential.where(webauthn_id: webauthn_credential.id);
        
        accountFound = false
        stored_credentials.each do |stored_credential|
            begin
                webauthn_credential.verify(
                    session[:authentication_challenge],
                    public_key: stored_credential.public_key,
                    sign_count: stored_credential.sign_count
                )

                stored_credential.update!(sign_count: webauthn_credential.sign_count)

                sign_in stored_credential.user

                accountFound = true;

                break
            rescue WebAuthn::Error => e
            end
        end

        if accountFound
            redirect_to todos_path
        end
    end
end
