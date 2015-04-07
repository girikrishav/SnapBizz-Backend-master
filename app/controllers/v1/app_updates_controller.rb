class V1::AppUpdatesController < ApplicationController
  # GET /app_updates/1
  # GET /app_updates/1.json
  def latest_apk_version
    billing_app = AppUpdate.where(:appname => 'Billing').last
    stock_app = AppUpdate.where(:appname => 'Stock').last
    push_offers = AppUpdate.where(:appname => 'PushOffer').last

    billing_app.path = request.protocol + request.host_with_port + "/v1/app_updates/download_apk?path=#{billing_app.path}&access_token=#{params[:access_token]}" if billing_app
    stock_app.path = request.protocol + request.host_with_port + "/v1/app_updates/download_apk?path=#{stock_app.path}&access_token=#{params[:access_token]}" if stock_app
    push_offers.path = request.protocol + request.host_with_port + "/v1/app_updates/download_apk?path=#{push_offers.path}&access_token=#{params[:access_token]}" if push_offers

    render json: {responseCode: 200, responseMessage: "success", response: { 
        billing: {version: billing_app.version_number.to_s, path: billing_app.path, created_at: billing_app.created_at.to_s(:db)}, 
        stock: {version: stock_app.version_number.to_s, path: stock_app.path, created_at: stock_app.created_at.to_s(:db)}, 
        push_offers: ({version: push_offers.version_number.to_s, path: push_offers.path, created_at: push_offers.created_at.to_s(:db)} rescue {})} }
  end

  def download_apk
    send_file  "#{Rails.root}/public/#{params[:path]}", :type=>"application/vnd.android.package-archive", :x_sendfile=>true
  end

  # POST /app_updates
  # POST /app_updates.json
  def create
    app_update = AppUpdate.new(params[:app_update])
    # uploaded_io = params[:person][:picture]
    # File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #   file.write(uploaded_io.read)
    # end
    if @app_update.save
      render json: @app_update, status: :created, location: @app_update
    else
      render json: @app_update.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /app_updates/1
  # PATCH/PUT /app_updates/1.json
  def update
    @app_update = AppUpdate.find(params[:id])

    if @app_update.update(params[:app_update])
      head :no_content
    else
      render json: @app_update.errors, status: :unprocessable_entity
    end
  end

  # DELETE /app_updates/1
  # DELETE /app_updates/1.json
  def destroy
    @app_update = AppUpdate.find(params[:id])
    @app_update.destroy

    head :no_content
  end
end
