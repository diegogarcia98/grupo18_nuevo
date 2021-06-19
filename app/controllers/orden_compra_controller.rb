## gema para las requests
require 'net/http'
## para el js date
require 'date'


=begin
oc = Orden_compra_recibida.find_by(oc_id: params[:oc_id])
    	render json: {id: oc.oc_id, 
        cliente: oc.cliente, 
        sku: oc.sku, 
        fechaEntrega: oc.fechaEntrega,
        cantidad: oc.cantidad,
        urlNotificacion: oc.urlNotificacion,
    	estado: oc.estado},status: :ok
=end

class OrdenCompraController < ApplicationController
  
  def recibir
  	url_api_oc = "https://dev.oc.2021-1.tallerdeintegracion.cl/oc"
  	# se recibe el id de la orden de compra
  	oc_id = params[:oc_id]
  	# se revisa que no este duplicada FALTA
  	if Orden_compra_recibida.exists?(oc_id: params[:oc_id])
  		oc = Orden_compra_recibida.find_by(oc_id: params[:oc_id])
    	render json: {mensaje: "OC ya fue recibida"},status: :bad_request
  	# Si esta duplicada se responde con un error 400 Bad request y con un json con {"mensaje": "OC ya fue recibida"}


  	# obtenemos url y se hace el request
  	oc_hash = url_api_oc + "/obtener/" + oc_id
  	url = url_api_oc + oc_hash
  	@oc_json = HTTParty.get(url).parsed_response
  	## se guarda la informacion en la bd
  	fecha_entrega = oc_json['fechaEntrega'].to_i
  	creada_en = Date.today.strftime("%Q").to_i
  	# ejemplo para crear instancias en un modelo: artist = Artist.create(artist_id: artist_id, name: artist_name, age: artist_age, albums_url: albums_url, tracks_url: tracks_url, self: self_url)
  	oc_nueva = Orden_compra_recibida.create(oc_id: oc_json['id'], cliente: oc_json['cliente'] , sku: oc_json['sku'], fechaEntrega: fecha_entrega, 
  		cantidad: oc_json['cantidad'], urlNotificacion: oc_json['urlNotificacion'], estado: "recibida", creacion: creada_en , en_despacho: false)
  	# se guadrda y se hace el response
  	if oc_nueva.save
        oc = Orden_compra_recibida.find_by(oc_id: params[:oc_id])
    	render json: {id: oc.oc_id, 
        cliente: oc.cliente, 
        sku: oc.sku, 
        fechaEntrega: oc.fechaEntrega,
        cantidad: oc.cantidad,
        urlNotificacion: oc.urlNotificacion,
    	estado: oc.estado},status: :created
      else
        sts = :bad_request

      end
  end

  def index
  end

  def show
  end

  def edit
  end
end
