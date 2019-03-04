class FlySitesController < ApplicationController
  before_action :set_fly_site, only: [:show, :update, :destroy]

  # GET /fly_sites
  def index
    @fly_sites = FlySite.within(40, origin: [37.819492, -122.189156])
    if params['sort']
      f = params['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      order = f[0] == '-' ? 'DESC' : 'ASC'
      if FlySite.new.has_attribute?(field)
        @fly_sites = @fly_sites.order("#{field} #{order}")
      end
    end
    @fly_sites = @fly_sites.page(params[:page] ? params[:page][:number] : 1)
    render json: @fly_sites
  end

  # GET /fly_sites/1
  def show
    render json: @fly_site
  end

  # POST /fly_sites
  def create
    @fly_site = FlySite.new(fly_site_params)

    if @fly_site.save
      render json: @fly_site, status: :created, location: @fly_site
    else
      render json: @fly_site.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fly_sites/1
  def update
    if @fly_site.update(fly_site_params)
      render json: @fly_site
    else
      render json: @fly_site.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fly_sites/1
  def destroy
    @fly_site.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fly_site
      begin
        @fly_site = FlySite.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        fly_site = User.new
        fly_site.errors.add(:id, "Wrong ID provided")
        render_error(fly_site, 404) and return
      end
    end

    # Only allow a trusted parameter "white list" through.
    def fly_site_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    end
end
