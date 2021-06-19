## gema para las requests
require 'net/http'

class OrdenCompraController < ApplicationController
  
  def recibir
  	url_api_oc = "https://dev.oc.2021-1.tallerdeintegracion.cl/oc"
  	# se recibe el id de la orden de compra
  	oc_id = params[:oc_id]

  	# se revisa que no este duplicada FALTA
  	# comando ejemplo: if Artist.exists?(artist_id: params[:a_id])
  	# Si esta duplicada se responde con un error 400 Bad request y con un json con {"mensaje": "OC ya fue recibida"} FALTA

  	# obtenemos url y se hace el request
  	oc_hash = "/obtener/" + oc_id
  	url = url_api_oc + oc_hash
  	@oc_json = HTTParty.get(url).parsed_response
  	## responder un error si es que no existe la orden de compra FALTA

  	## se guarda el json en la bd, con "estado" = "recibida"  FALTA
  	## Se manda la respuesta con un status 201 Creates y con un json con parametro estado = "recibida" FALTA

  end

  def index
  end

  def show
  end

  def edit
  end
end
