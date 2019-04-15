import flatpickr from "flatpickr";

class AjaxForm {

  constructor(option) {
    this.$el = $(option.el);
    this.initDateTimePicker();
    this.$submit = this.$el.find('[type=submit]');
    this.$el.on('submit', $.proxy(this.submit, this));
  }

  initDateTimePicker() {
    this.$datetime = this.$el.find('.form-group-datetime');
    this.$datetime.find('.form-control-date').flatpickr({ altInput: true, altFormat: 'Y/m/d'});
  }

  submit(e) {
    this.hideErrorMessage();
    let formData = new FormData(this.$el[0]);

    $.ajax({
      url: this.$el.attr('action'),
      type: this.$el.attr('method'),
      data: formData,
      processData: false,
      contentType: false,
      beforeSend: $.proxy(this.beforeSendHandler, this),
      success: $.proxy(this.successHandler, this),
      error: $.proxy(this.errorHandler, this),
      complete: $.proxy(this.completeHandler, this)
    });
    return false;
  }

  beforeSendHandler(xhr, settings) {
    this.$submit.prop('disabled', true)
  }

  successHandler(data, textStatus, jqXHR) {
    console.log(data, "successHandler");
    if (data.redirect_to) {
      window.location = data.redirect_to;
    }
  }

  errorHandler(jqXHR, textStatus, errorThrown) {
    let response = jqXHR.responseJSON;
    if (response) {
      if (response.errors) {
        this.showErrorMessage(response.errors);
      }
    } else {
      alert('通信に失敗しました。ネットワークの設定を確認してください。');
    }
    this.$submit.prop('disabled', false);
  }

  completeHandler(data, textStatus) {
  }

  showErrorMessage(errors) {
    let $target = this.$el.find('#alert-message');
    let $alertHtml = $('<div class="alert alert-danger errors"></div>');
    $alertHtml.append(errors.join('<br>'));
    if ($target.length > 0) {
      $alertHtml.appendTo($target);
    } else {
      $alertHtml.insertBefore(this.$submit);
    }
  }

  hideErrorMessage() {
    this.$el.find('.alert.errors').remove();
  }
}

export default AjaxForm;
