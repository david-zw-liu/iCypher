class CypherController < ApplicationController
  protect_from_forgery except: :encrypt
  protect_from_forgery except: :decrypt

  def encrypt
    result = {is_succeed: false, msg: ""}
    me = User.find_by(access_key: params["access_key"])
    to_whom = User.find_by(username: params["to_whom"])
    plain_text = params["plain_text"]

    me_private_key = RSA::Key.new(me.modulus, me.private_exponent.to_i)
    to_whom_public_key = RSA::Key.new(to_whom.modulus, to_whom.public_exponent.to_i)

    if(me.nil?)
      result[:msg] = "Please Login!"
    else
      key_pair = RSA::KeyPair.new(me_private_key, to_whom_public_key)
      result[:signature] = Base64.encode64(key_pair.sign(plain_text))
      result[:cypher] =  Base64.encode64(key_pair.encrypt(plain_text))
      result[:msg] = "Encrypt finished!"
      result[:is_succeed] = true
    end
    render :json => result
  end
  def decrypt
    result = {is_succeed: false, msg: ""}
    signature = Base64.decode64(params['signature'])
    cypher = Base64.decode64(params['cypher'])
    me = User.find_by(access_key: params["access_key"])
    from_whom = User.find_by(username: params["from_whom"])

    me_private_key = RSA::Key.new(me.modulus, me.private_exponent.to_i)
    from_whom_public_key = RSA::Key.new(from_whom.modulus, from_whom.public_exponent.to_i)


    if(me.nil?)
      result[:msg] = "Please Login!"
    else
      key_pair = RSA::KeyPair.new(me_private_key, from_whom_public_key)
      result[:plain_text] = key_pair.decrypt(cypher)
      if(key_pair.verify(signature,result[:plain_text]))
        result[:is_succeed] = true
        result[:signature_status] = true
        result[:msg] = "Decrypt finished!"
      else
        result[:signature_status] = false
        result[:msg] = "Something wrong! Please retry again."
        result.delete(:plain_text)
      end
    end
    render :json => result
  end
end
