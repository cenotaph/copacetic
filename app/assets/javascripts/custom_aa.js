/* Active Admin JS */
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require ckeditor/init
//= require jquery_nested_form
var CKEDITOR_BASEPATH = '/assets/ckeditor/';

$(function(){
  $(".datepicker").datepicker({dateFormat: 'yy-mm-dd'});

  $(".clear_filters_btn").click(function(){
    window.location.search = "";
    return false;
  });
});
