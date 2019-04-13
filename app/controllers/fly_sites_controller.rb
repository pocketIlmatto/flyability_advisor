include Geokit::Geocoders

class FlySitesController < ApplicationController
  before_action :set_fly_site, only: [:show, :edit, :update, :destroy, :favorite]

  # GET /get_fly_sites
  def get_fly_sites
    location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
    Rails.logger.info "event=ip_address_reverese_geocode_lookup ip=#{request.remote_ip}"
    if location.success
      @fly_sites = FlySite.within(40, origin: [location.lat, location.lng])
    else
      @fly_sites = FlySite.all
    end

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
    @lat = @fly_site.lat
    @lng = @fly_site.lng
    @fly_site
  end

  # POST /fly_sites
  def create
    @fly_site = FlySite.new(fly_site_params)

    if @fly_site.save
      redirect_to @fly_site, notice: 'Flying site was successfully created.'
    else
      render :new
    end
  end

  # GET /fly_sites/new
  def new
    @fly_site = FlySite.new
  end

  # GET /fly_sites/1/edit
  def edit
  end

  # PATCH/PUT /fly_sites/1
  def update
    if @fly_site.update(fly_site_params)
      redirect_to @fly_site, notice: 'Flying site was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /fly_sites/1
  def destroy
    @fly_site.destroy
    redirect_to fly_sites_url, notice: 'Flying site was successfully destroyed.'
  end

  def favorite
    if user_signed_in?
      if current_user.favorited?(@fly_site)
        @fly_site.user_ids = @fly_site.user_ids - [current_user.id]
      else
        @fly_site.users << current_user
      end
      @fly_site.save!
      current_user.reload
    else
      @fly_site.errors.add(base: :must_be_logged_in_to_favorite)
    end
    
    respond_to do |format|
      format.html do
        if @fly_site.valid?
          flash[:notice] = "Favorite updated"
        else
          flash[:error] = "#{@fly_site.errors.full_messages}"
        end
        redirect_to :back 
      end
      format.js
    end
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
