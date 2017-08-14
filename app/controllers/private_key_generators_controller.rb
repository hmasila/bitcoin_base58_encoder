class PrivateKeyGeneratorsController < ApplicationController
  def create
    @base58 = PrivateKeyGenerator.create!(base58converter_params)
    json_response(@base58, :created)
  end

  # GET /todos/:id
  def show
    json_response(@base58)
  end

  private

  def base58converter_params
    # whitelist params
    params.permit(:address)
  end

  def set_base58
    @base58 = PrivateKeyGenerator.find(params[:id])
  end
end
