import * as activestorage from "@rails/activestorage"
import { DirectUpload } from "@rails/activestorage";

activestorage.start();

const input = document.querySelector('input[type=file][data-direct-upload-url]:not([disabled])');

// Bind to normal file selection
input.addEventListener('change', (event) => {
  const fileInput = event.target;
  let titleEl = document.getElementById('csv_upload_title');

  if(titleEl) {
    if(titleEl.value === null || titleEl.value.match(/^ *$/) !== null) {
      titleEl.value = fileInput.value.split(/(\\|\/)/g).pop().replace('.csv', '');
    }
  }
  Array.from(input.files).forEach(file => uploadFile(file, fileInput))
  // you might clear the selected files from the input
  input.value = null
})

const uploadFile = (file, fileInput) => {
  // your form needs the file_field direct_upload: true, which
  //  provides data-direct-upload-url
  const url = input.dataset.directUploadUrl;
  new Uploader(file, url, fileInput);
}

class Uploader {
  constructor(file, url, fileInput) {
    this.file = file;
    this.uid = String(Date.now().toString(32) + Math.random().toString(16)).replace(/\./g, '');
    this.url = url;
    this.upload = new DirectUpload(this.file, this.url, this);
    this.fileInput = fileInput;
    this.parser = new DOMParser();
    this.progressTemplate = this.fileInput.form.querySelector('template.directupload-progress').innerHTML
    this.progressDiv = document.createElement('div')
    this.fileInput.after(this.progressDiv);
    this.fileInput.blur();

    this.progressDiv.id = 'directupload-progress-' + this.uid;
    if(this.progressTemplate != null) {
      let templateWithFilename = document.createElement('div');
      templateWithFilename.innerHTML = this.progressTemplate;
      templateWithFilename.querySelector('span.directupload-progress-filename').textContent = file.name;

      this.progressTemplate = templateWithFilename.innerHTML;
      let parsedTemplate = this.progressTemplate.replaceAll('{{status}}', 'Uploading');
      parsedTemplate.replaceAll('{{progress}}', 0);
      this.progressDiv.innerHTML = parsedTemplate;
    }

    this.upload.create((error, blob) => {
      if (error) {
        // Handle the error
        this.progressDiv.innerHTML = this.progressTemplate
          .replaceAll('{{status}}', 'Error')
          .replaceAll('{{progress}}', 0)
      } else {
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

  directUploadDidProgress(event) {
    console.log(event, Math.max(1, Math.floor((event.loaded / event.total) * 100)));

    this.progressDiv.innerHTML = this.progressTemplate
      .replaceAll('{{status}}', 'Uploading')
      .replaceAll('{{progress}}', Math.max(1, Math.floor((event.loaded / event.total) * 100)));
  }
}
