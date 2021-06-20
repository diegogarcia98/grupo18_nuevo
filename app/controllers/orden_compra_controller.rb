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
	protect_from_forgery with: :null_session
	def recibir
		url_api_oc = "https://dev.oc.2021-1.tallerdeintegracion.cl/oc"
		# se recibe el id de la orden de compra
		oc_id = params[:oc_id]
		# se revisa que no este duplicada FALTA
		if OrdenCompraRecibida.exists?(oc_id: params[:oc_id])
			oc =OrdenCompraRecibida.find_by(oc_id: params[:oc_id])
			render json: {mensaje: "OC ya fue recibida"},status: :bad_request
		# Si esta duplicada se responde con un error 400 Bad request y con un json con {"mensaje": "OC ya fue recibida"}
		# obtenemos url y se hace el request
	  	else
		  url = url_api_oc + "/obtener/" + oc_id
		  @oc_json = HTTParty.get(url).parsed_response
		  ## se guarda la informacion en la bd
		  fecha_entrega = Time.at(oc_json['fechaEntrega'].to_i/1000)
		  creada_en = Time.now
		  # ejemplo para crear instancias en un modelo: artist = Artist.create(artist_id: artist_id, name: artist_name, age: artist_age, albums_url: albums_url, tracks_url: tracks_url, self: self_url)
		  oc_nueva = OrdenCompraRecibida.create(oc_id: oc_json['id'], cliente: oc_json['cliente'] , sku: oc_json['sku'], fechaEntrega: fecha_entrega, 
			  cantidad: oc_json['cantidad'], urlNotificacion: oc_json['urlNotificacion'], estado: "recibida", creacion: creada_en , en_despacho: false)
		  # se guadrda y se hace el response
		  if oc_nueva.save
			oc = OrdenCompraRecibida.find_by(oc_id: params[:oc_id])
			render json: {id: oc.oc_id, 
			  cliente: oc.cliente, 
			  sku: oc.sku, 
			  fechaEntrega: oc.fechaEntrega.to_i,
			  cantidad: oc.cantidad,
			  urlNotificacion: oc.urlNotificacion,
			  estado: oc.estado},status: :created
		  else
			render status: :bad_request
		  end
	  	end
	  	
	end

  def index
  end

  def show
  end

  def actualizar_estado
	decision = params[:estado]
	url_api = "https://dev.oc.2021-1.tallerdeintegracion.cl/oc/"
	#falta decidir que pasa cuando no vienen los parámetros correctos
	#Revisar si existe registro de este id en nuestra BD  
	oc = OrdenCompraRecibida.find_by(oc_id: params[:oc_id])
	if oc == nil 
		render json: {"mensaje": "No hay registros con ese ID"}, status: 404   #no existe id con estos datos en nuestra BD
	else
		if decision == "aceptada"
			#avisamos a la API OC
			HTTParty.post(url_api+"recepcionar/"+params[:oc_id])
			#avisamos al grupo correspondiente a la dirección entregada
			HTTParty.patch(oc.urlNotificacion, body: {_id: oc.oc_id, estado: "aceptada"})
			render status: 204
		elsif decision == "rechazada"
			#avisamos a la API OC
			HTTParty.post(url_api+"rechazar/"+params[:oc_id])
			#avisamos al grupo correspondiente a la dirección entregada
			HTTParty.patch(oc.urlNotificacion, body: {_id: oc.oc_id, estado: "rechazada"})
			render status: 204
		end
	end
  end
end
