require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    context 'can save' do    #  メッセージを保存できる場合
      it 'is valid with content' do    #  メッセージがあれば保存できる
        expect(build(:message, image: nil)).to be_valid
      end

      it 'is valid with image' do    #  画像があれば保存できる
        expect(build(:message, content: nil)).to be_valid
      end

      it 'is valid with content and image' do    #  メッセージと画像があれば保存できる
        expect(build(:message)).to be_valid
      end
    end

    context 'can not save' do    #  メッセージを保存できない場合
      it 'is invalid without content and image' do    #  メッセージも画像も無いと保存できない
        message = build(:message, content: nil, image: nil)
        message.valid?
        expect(message.errors[:content]).to include('を入力してください')
      end

      it 'is invalid without group_id' do    #  group_idが無いと保存できない
        message = build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include('を入力してください')
      end

      it 'is invaid without user_id' do     # user_idが無いと保存できない
        message = build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include('を入力してください')
      end
    end
  end
end