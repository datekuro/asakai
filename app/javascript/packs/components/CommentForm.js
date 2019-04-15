import AjaxForm from "./AjaxForm";

class CommentForm extends AjaxForm {

  submit(e) {
    e.preventDefault();
    if (this.$el.find('textarea').val() == '') {
      return false;
    }
    super.submit();
  }

  successHandler(data, textStatus, jqXHR) {
    data = JSON.parse(data)
    const $comment_container_id = $(`#comment-list-${data.article_id}`)
    $comment_container_id.empty()
    $comment_container_id.html(data.body);
  }

  completeHandler(data, textStatus) {
    this.$el.each((k, v) => {
      v.reset();
      $(v).find('[type=submit]').prop('disabled', false)
    })
  }

  initForm() {
    this.$el.find('textarea').val('');
  }
}

export default CommentForm;
