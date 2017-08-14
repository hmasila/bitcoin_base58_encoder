class PrivateKeyGenerator < ApplicationRecord
  validates_presence_of :address
  before_create :generate_private_key

  def generate_private_key
    key = Bitcoin::hash160_from_address(address)
    compressed = "80".b + key
    checksum = compressed + checksum(compressed)

    self.private_key = encode_base58(checksum)
  end

  def checksum(hex)
    b = [hex].pack("H*") # unpack hex
    Digest::SHA256.hexdigest( Digest::SHA256.digest(b) )[0...8]
  end

  def int_to_base58(int_val, leading_zero_bytes=0)
    alpha = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    base58_val, base = '', alpha.size
    while int_val > 0
      int_val, remainder = int_val.divmod(base)
      base58_val = alpha[remainder] + base58_val
    end
    base58_val
  end

  def encode_base58(hex)
    leading_zero_bytes  = (hex.match(/^([0]+)/) ? $1 : '').size / 2
    ("1"*leading_zero_bytes) + int_to_base58( hex.to_i(16) )
  end

  def hash160_from_address(address)
    return nil  unless valid_address?(address)
    decode_base58(address)[2...42]
  end
end
