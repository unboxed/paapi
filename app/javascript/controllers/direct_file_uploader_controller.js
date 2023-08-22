import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  handleFileSelect(event) {
    const fileInput = event.target;
    const titleEl = document.getElementById('csv_upload_title')

    // if no title is given, put a title in from the provided file
    if (titleEl && (!titleEl.value || titleEl.value.trim() === '')) {
      // get the filename, without the extension
      const fileName = fileInput.value.split(/(\\|\/)/g).pop().replace('.csv', '')
      titleEl.value = fileName
    }

    Array.from(fileInput.files).forEach(file => this.uploadFile.call(this, file, fileInput))
  }

  uploadFile(file, fileInput) {
    const url = fileInput.dataset.directUploadUrl;
    new Uploader(file, url, fileInput, this.progressTemplate);
  }
}

class Uploader {
  // constructs and starts upload
  constructor(file, url, fileInput) {
    // file object, with metadata
    this.file = file;
    // create a uid for general dom selection
    this.uid = String(Date.now().toString(32) + Math.random().toString(16)).replace(/\./g, '');
    this.url = url;
    this.upload = new DirectUpload(this.file, this.url, this);
    this.fileInput = fileInput;

    // create the template in the capturing form
    this.progressTemplate = this.fileInput.form.querySelector('template.directupload-progress').innerHTML
    this.progressDiv = document.createElement('div')
    this.fileInput.after(this.progressDiv);
    this.fileInput.blur();

    // add the uid as an ID to the new element
    this.progressDiv.id = 'directupload-progress-' + this.uid;
    if(this.progressTemplate != null) {
      // create a new template containing the filename and immutable details
      let templateWithFilename = document.createElement('div');
      templateWithFilename.innerHTML = this.progressTemplate;
      templateWithFilename.querySelector('span.directupload-progress-filename').textContent = file.name;
      this.progressTemplate = templateWithFilename.innerHTML;

      // initialise the new template at 0% progress, and insert in form
      let parsedTemplate = this.progressTemplate.replaceAll('{{status}}', 'Uploading');
      parsedTemplate.replaceAll('{{progress}}', 0);
      this.progressDiv.innerHTML = parsedTemplate;
    }

    this.upload.create((error, blob) => {
      if (error) {
        // Notify that there was an error, set to 0%
        this.progressDiv.innerHTML = this.progressTemplate
          .replaceAll('{{status}}', 'Error')
          .replaceAll('{{progress}}', 0)
      } else {
        // Add a hidden field to end of form containing details and signed id
        const hiddenField = document.createElement('input')
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("value", blob.signed_id);
        hiddenField.name = this.fileInput.value.split(/(\\|\/)/g).pop().replace('.csv', '')
        this.fileInput.form.appendChild(hiddenField);
        this.progressDiv.innerHTML = this.progressTemplate
        .replaceAll('{{status}}', 'Uploaded')
        .replaceAll('{{progress}}', 100);
      }
    })
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress",
      event => this.directUploadDidProgress(event))
  }

  // update the progress element
  directUploadDidProgress(event) {
    this.progressDiv.innerHTML = this.progressTemplate
      .replaceAll('{{status}}', 'Uploading')
      .replaceAll('{{progress}}', Math.max(1, Math.floor((event.loaded / event.total) * 100)));
  }
}
