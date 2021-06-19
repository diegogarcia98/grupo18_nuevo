require 'json'
require 'rest-client'
require "base64"
class StockController < ApplicationController
  def index
    @recepcion = "60bd3477f955380004edaa38"
    @despacho = "60bd3477f955380004edaa39"
    @pulmon = "60bd3477f955380004edaa3b"
    @normal = "60bd3477f955380004edaa3a"
    @almacenes = [@recepcion, @despacho,@pulmon, @normal]
    
    dic = {}
    @almacenes.each do |almacen|
      @url = "https://dev.api-bodega.2021-1.tallerdeintegracion.cl/bodega/skusWithStock?almacenId=#{almacen}"  
      response = RestClient.get @url, :Authorization => "INTEGRACION grupo18:"+get_hash("GET"+almacen)
      result = JSON.parse response.to_str
      if result.length() == 0
        dic[almacen] = "almacen vacío"
      else
        dic[almacen] = result
      end
    end  
    render json: dic, status: 200
      
    
  end

  def show
    #@url = 'https://dev.api-bodega.2021-1.tallerdeintegracion.cl/bodega/almacenes'
    #@response = RestClient.get @url, :Authorization => 'INTEGRACION grupo18:/2xZ/LaB8vO2WCN8HzHVOcFq7AU='
    #@result = JSON.parse @response.to_str
    #render json: @result, status: 200
  end

  def update
  end

  def delete
  end

  def get_hash(data)
    @token = "ivHP8KdoxvnD;:H"
    @data = data
    @hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'),@token,@data)
    @hash = Base64.encode64(@hmac).chomp
    return @hash
  end
end
