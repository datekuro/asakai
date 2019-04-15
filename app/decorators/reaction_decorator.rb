module ReactionDecorator
  def emoji_image_path
    case self.code
      when 'thumbs_up'
        path = 'media/images/emoji/unicode/1f44d.png'
      when 'thumbs_down'
        path = 'media/images/emoji/unicode/1f44e.png'
      when 'heart'
        path = 'media/images/emoji/unicode/2764.png'
      when 'exclamation'
        path = 'media/images/emoji/unicode/2757.png'
      when 'question'
        path = 'media/images/emoji/unicode/2753.png'
      when 'interrobang'
        path = 'media/images/emoji/unicode/2049.png'
      else
        path = ''
    end
    path
  end

end
