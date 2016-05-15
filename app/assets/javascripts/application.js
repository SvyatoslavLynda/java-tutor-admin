// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap
//= require turbolinks
//= require_tree .
//= require froala_editor.min
//= require plugins/image.min


$(function() {
  $('#edit').froalaEditor( {
    imageAllowedTypes: ['jpeg', 'jpg', 'png'],
    htmlAllowedTags: ['ul', 'ol', 'li', 'a', 'img', 'font', 'b', 'strong', 'em', 'i', 'u', 'p', 'br', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'],
    toolbarButtons: ["bold", "italic", "underline", "insertImage", "undo", "redo", "html"],
    toolbarButtonsMD: ["bold", "italic", "underline", "insertImage", "undo", "redo", "html"],
    toolbarButtonsSM: ["bold", "italic", "underline", "insertImage", "undo", "redo", "html"],
    toolbarButtonsXS: ["bold", "italic", "underline", "insertImage", "undo", "redo", "html"],
    //formatTags: ["ul", "ol", "li", "a", "img", "font", "b", "i", "u", "p", "br", "h1", "h2", "h3", "h4", "h5", "h6"],
    paragraphFormat: {
      N: 'Normal',
      H1: 'Heading 1',
      h2: 'Heading 2',
      h3: 'Heading 3',
      h4: 'Heading 4',
      h5: 'Heading 5',
      h6: 'Heading 6'
    },
    useClasses: false,
    imageDefaultAlign: "left",
    imageDefaultDisplay: "block"
  } )
});