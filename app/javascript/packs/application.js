/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
const images = require.context('../images', true)
import 'material-dashboard/assets/js/core/jquery.min'
import 'material-dashboard/assets/js/core/popper.min'
import 'material-dashboard/assets/js/core/bootstrap-material-design.min'
import 'material-dashboard/assets/js/material-dashboard'
import 'material-dashboard/assets/js/plugins/bootstrap-notify'
import 'material-dashboard/assets/js/plugins/perfect-scrollbar.jquery.min'
import 'bootstrap-select/dist/js/bootstrap-select.min'
import '../stylesheets/application'
import Rails from 'rails-ujs'

import AjaxForm from './components/AjaxForm';
import CommentForm from './components/CommentForm';
import ReactionForm from './components/ReactionForm';

Rails.start()

$(() => {
  $('.ajax-form').each((i, el) => new AjaxForm({ el: el }));
  $('.comment-form').each((i, el) => new CommentForm({ el: el }));

  $(document).on('focus', '[name=published_date]', function(e){
    e.preventDefault();
    $(e.currentTarget).flatpickr()
  })

  $('[data-toggle="popover"]').popover({
    html: true,
    trigger: 'focus',
    content: function() {
      return $('#' + $(this).data('custom_id')).html();
    }
  });

  $('.reaction-icon-action').on('shown.bs.popover', function(e){
    $('.reaction-form').each((i, el) => new ReactionForm({ el: el }));
  })

  // WORKAROUND
  $('.disabled-default-ajax-form').on('ajax:beforeSend', function(e, xhr, settings) {
    return false;
  });
});
