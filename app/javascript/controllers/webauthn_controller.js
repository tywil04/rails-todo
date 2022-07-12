import { Controller } from "@hotwired/stimulus";

function base64urlToBuffer(baseurl64String) {
  const padding = "==".slice(0, (4 - (baseurl64String.length % 4)) % 4);
  const base64String = baseurl64String.replace(/-/g, "+").replace(/_/g, "/") + padding;
  const string = atob(base64String);

  const buffer = new ArrayBuffer(string.length);
  const byteView = new Uint8Array(buffer);
  for (let i = 0; i < string.length; i++) {
    byteView[i] = string.charCodeAt(i);
  }
  return buffer;
}

function bufferToBase64url(buffer) {
  const byteView = new Uint8Array(buffer);
  let string = "";
  for (const charCode of byteView) {
    string += String.fromCharCode(charCode);
  }

  const base64String = btoa(string);
  const base64urlString = base64String.replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "");
  
  return base64urlString;
}

export default class extends Controller {
    static targets = ["button", "output"];

    start() {
        var optionsResponse = fetch("/webauthn/register.json");

        optionsResponse.then(response => response.json().then(options => {
            options.challenge = base64urlToBuffer(options.challenge)
            options.user.id = base64urlToBuffer(options.user.id)

            console.log(options)
            const credential = navigator.credentials.create({
                publicKey: options,
            })

            credential.then(publicKeyCredential => {
                console.log(publicKeyCredential)
                var jsonPublicKeyCredential = {
                    authenticatorAttachment: publicKeyCredential.authenticatorAttachment,
                    id: publicKeyCredential.id,
                    rawId: bufferToBase64url(publicKeyCredential.rawId),
                    response: {
                        attestationObject: bufferToBase64url(publicKeyCredential.response.attestationObject),
                        clientDataJSON: bufferToBase64url(publicKeyCredential.response.clientDataJSON),
                    },
                    type: publicKeyCredential.type,
                    clientExtensionResults: publicKeyCredential.getClientExtensionResults(),
                }

                console.log(jsonPublicKeyCredential)
                fetch(`/webauthn/register/verify?publicKeyCredential=${JSON.stringify(jsonPublicKeyCredential)}`)
            })
        }))
    }
}