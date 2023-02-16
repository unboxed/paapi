# frozen_string_literal: true

class CsvUploadsController < ApplicationController
  before_action :set_csv_upload, only: %i[show edit update destroy]

  # GET /csv_uploads or /csv_uploads.json
  def index
    @csv_uploads = CsvUpload.all
  end

  # GET /csv_uploads/1 or /csv_uploads/1.json
  def show; end

  # GET /csv_uploads/new
  def new
    @csv_upload = CsvUpload.new
  end

  # GET /csv_uploads/1/edit
  def edit; end

  # POST /csv_uploads or /csv_uploads.json
  def create
    @csv_upload = CsvUpload.new(csv_upload_params)

    respond_to do |format|
      if @csv_upload.save
        format.html do
          redirect_to csv_upload_url(@csv_upload), I18n.t("upload_successfully_created_notice")
        end
        format.json { render :show, status: :created, location: @csv_upload }
        start_job
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
        format.html { redirect_to csv_upload_url(@csv_upload), notice: I18n.t("upload_successfully_updated_notice") }
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
      format.html { redirect_to csv_uploads_url, notice: I18n.t("upload_successfully_destroyed_notice") }
      format.json { head :no_content }
    end
  end

  private

  def start_job
    DownloadLocalCopyStartJob.set(wait: 2.seconds).perform_later @csv_upload
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_csv_upload
    @csv_upload = CsvUpload.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def csv_upload_params
    params.require(:csv_upload).permit(:title, csv_files: [])
  end
end
