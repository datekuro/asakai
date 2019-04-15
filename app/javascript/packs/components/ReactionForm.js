class ReactionForm {

  constructor(option) {
    this.$el = $(option.el);
    this.$submit = this.$el.find('[type=submit]');
    this.$el.on('click', '[type=submit]', $.proxy(this.submit, this));
  }

  submit(e) {
    e.preventDefault();
    this.hideErrorMessage();
    let formData = new FormData(this.$el[0]);
    formData.set("reaction[code]", $(e.currentTarget).val())

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
  }

  successHandler(data, textStatus, jqXHR) {
    const $reaction_container_id = $(`#reaction-result-list-${data.reactionable_type}-${data.reactionable_id}`)
    $reaction_container_id.empty()
    $reaction_container_id.html(data.body);
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

export default ReactionForm;
