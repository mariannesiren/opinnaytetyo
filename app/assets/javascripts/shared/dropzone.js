Dropzone.autoDiscover = false;

$(document).on("turbolinks:load", function() {
  $(".dropzone").each(function () {
    var collection = $(this).prev();
    var multiple = $(this).hasClass("multiple");
    var disabled = $(this).hasClass("disabled");
    var dropzone = new Dropzone(this, {
      url: '#',
      method: 'post',
      autoQueue: false,
      autoProcessQueue: false,
      maxFiles: multiple ? 25 : 1,
      addRemoveLinks: !disabled,
      init: function() {
        var current_dropzone = this;

        if (disabled) current_dropzone.removeEventListeners();

        if (collection.hasClass("files")) {
          collection.children('div').each(function() {
            var mock_file = {
              name: $(this).find('.dz-name').text(),
              size: $(this).find('.dz-size').text(),
              type: $(this).find('.dz-type').text(),
              id: $(this).find('.dz-key').text()
            };
            current_dropzone.emit("addedfile", mock_file);
            if ($(this).find('.dz-thumbnail').text().length) {
              current_dropzone.emit("thumbnail", mock_file, $(this).find('.dz-thumbnail').text());
            }
            var downloadLink = $(this).find('.dz-download-path').text()
            if (downloadLink.length) {
              addDownloadLink(mock_file, downloadLink);
            }
            current_dropzone.emit("complete", mock_file);
          });
        }
        this.on("maxfilesexceeded", function(file) {
          this.removeFile(file);
        });

        this.on('queuecomplete', function(file) {
          if (this.files.length > this.options.maxFiles) {
            this.removeFile(file);
          }
        });

        this.on("removedfile", function(file) {
          if (multiple) {
            if (file.additionalData) {
              // File only in UI, we remove the field
              $("[data-s3key="+file.additionalData.key.match(/cache\/(.+)/)[1]+"]").remove();
            } else {
              // File in model so we mark it for destroy
              $("[data-s3key="+file.id+"][data-role='destroy']").val(true)
            }
          } else {
            // How to delete single files?
            if (file.additionalData) {
              $("[data-s3key="+file.additionalData.key.match(/cache\/(.+)/)[1]+"]").val("")
            } else {
              $("[data-s3key="+file.id+"]").val("")
            }
          }
        });

        this.on('addedfile', function(file) {
          fetch('/presign', {
            method: 'get'
          }).then(function (response) {
            return response.json();
          }).then(function (json) {
            file.uploadURL = json.url;
            file.additionalData = json.fields;
            dropzone.processFile(file);
          });
        });

        this.on('processing', function(file) {
          this.options.url = file.uploadURL;
        });

        this.on('sending', function(file, xhr, formData) {
          for (var field in file.additionalData) {
            formData.append(field, file.additionalData[field]);
          }
        });

        this.on('success', function(file) {
          var fileData = {
            id: file.additionalData.key.match(/cache\/(.+)/)[1], // Remove the prefix part
            storage: 'cache',
            metadata: {
              size: file.size,
              filename:  file.name,
              mime_type: file.type
            }
          };
          newField = $("<input type='hidden'/>");
          var name = $(this.element).data("input-name");
          newField.prop("name", name.replace("id", new Date().getTime()));
          newField.attr("data-s3key", fileData.id);
          newField.val(JSON.stringify(fileData));
          newField.appendTo($(this.element));
        });
      }
    });
  });
});

function addDownloadLink(file, url) {
  var downloadLink = Dropzone.createElement("<a class='dz-remove' href='" + url + "'>Download file</a>");
  file.previewElement.appendChild(downloadLink);
}
