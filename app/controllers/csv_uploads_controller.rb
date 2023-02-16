class CsvUploadsController < ApplicationController
  before_action :set_csv_upload, only: %i[ show edit update destroy ]

  # GET /csv_uploads or /csv_uploads.json
  def index
    @csv_uploads = CsvUpload.all
  end

  # GET /csv_uploads/1 or /csv_uploads/1.json
  def show
  end

  # GET /csv_uploads/new
  def new
    @csv_upload = CsvUpload.new
  end

  # GET /csv_uploads/1/edit
  def edit
  end

  # POST /csv_uploads or /csv_uploads.json
  def create
    @csv_upload = CsvUpload.new(csv_upload_params)

    respond_to do |format|
      if @csv_upload.save
        format.html { redirect_to csv_upload_url(@csv_upload), notice: "Upload was successfully created. You can now monitor it's import progress." }
        format.json { render :show, status: :created, location: @csv_upload }
        DownloadLocalCopyStartJob.set(wait: 2.seconds).perform_later @csv_upload
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @csv_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /csv_uploads/1 or /csv_uploads/1.json
  def update
    respond_to do |format|
      if @csv_upload.update(csv_upload_params)
        format.html { redirect_to csv_upload_url(@csv_upload), notice: "Upload was successfully updated." }
        format.json { render :show, status: :ok, location: @csv_upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @csv_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /csv_uploads/1 or /csv_uploads/1.json
  def destroy
    @csv_upload.destroy

    respond_to do |format|
      format.html { redirect_to csv_uploads_url, notice: "CSV Upload was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_csv_upload
      @csv_upload = CsvUpload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def csv_upload_params
      params.require(:csv_upload).permit(:title, csv_files: [])
    end
end
