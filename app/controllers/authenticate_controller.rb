class AuthenticateController < ApplicationController
  USERS_MS = "http://ms-users.ms-users:3000/"

  def authUser()
    options = {
      :body => {
        :email => params[:email],
        :password => params[:password]
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json'
      }
    }
    result = HTTParty.post(USERS_MS + "authenticate", options)
    if result["token"]
      render json: {
        token: result["token"],
        }, status: :ok
      else
        render json: {
          message: "Usuario y/ó contraseña invalidos",
          }, status: :unauthorized
        end
      end

      def logout
        options = {
          :headers => {
            'Accept' => 'application/json',
            'Authorization' => request.headers["Authorization"]
          }
        }
        result = HTTParty.get(USERS_MS + "logout", options)

        if result.code == 200
          render json: {
            message: "Se realizó el logout correctamente",
            }, status: :ok
          else
            render json: {
              message: "El token no es valido o ya expriró",
              }, status: :unauthorized
              return false
            end
          end

          def self.checkToken(token)
            options = {
              :headers => {
                'Accept' => 'application/json',
                'Authorization' => token
              }
            }
            result = HTTParty.get(USERS_MS + "authorize", options)

            if result.code == 200
              return result
            else
              render json: {
                message: "El token no es valido o ya expriró",
                }, status: :unauthorized
                return false
              end
            end
          end
