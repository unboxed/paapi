import * as activestorage from "@rails/activestorage"
import { DirectUpload } from "@rails/activestorage";

activestorage.start();

// only select 'data-direct-upload' file inputs
const input = document.querySelector('input[type=file][data-direct-upload-url]:not([disabled])');

// bound to file select
input.addEventListener('change', (event) => {
  const fileInput = event.target;

  // if no title is given, put a title in from the provided file
  let titleEl = document.getElementById('csv_upload_title');
  if(titleEl) {
    if(titleEl.value === null || titleEl.value.match(/^ *$/) !== null) {
      // get the filename, without the extension
      titleEl.value = fileInput.value.split(/(\\|\/)/g).pop().replace('.csv', '');
    }
  }
  Array.from(input.files).forEach(file => uploadFile(file, fileInput))
  // clear the selected files from the file input
  input.value = null
})

const uploadFile = (file, fileInput) => {
  const url = input.dataset.directUploadUrl;
  new Uploader(file, url, fileInput);
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
        hiddenField.name = input.name;
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