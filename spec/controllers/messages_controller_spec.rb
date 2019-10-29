require 'rails_helper'

describe MessagesController do
  # letを利用してテスト中使用するインスタンスを定義
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do

    # 今回の場合、テストのケースがメッセージを保存できる場合、メッセージを保存できない場合で分かれています。
    # このように、特定の条件でテストをグループ分けしたい場合、contextを使うことができます。

    context 'log in' do    #  ログインしている場合のテスト
      before do    #  beforeブロックの内部に記述された処理は、各exampleが実行される直前に、毎回実行されます。beforeブロックに共通の処理をまとめることで、コードの量が減り、読みやすいテストを書くことができます。
        login user    #  deviseを用いて「ログインをする」ためのloginメソッドは、support/controller_macros.rbで定義したものです。
        get :index, params: { group_id: group.id }    #  messagesのルーティングはgroupsにネストされているため、group_idを含んだパスを生成します。そのため、getメソッドの引数として、params: { group_id: group.id }を渡しています。
      end

      it 'assigns @message' do    #  アクション内で定義しているインスタンス変数があるか
        expect(assigns(:message)).to be_a_new(Message)    #  @messageはMessage.newで定義された新しいMessageクラスのインスタンスです。be_a_newマッチャを利用することで、 対象が引数で指定したクラスのインスタンスかつ未保存のレコードであるかどうか確かめることができます。
      end

      it 'assigns @group' do    #  アクション内で定義しているインスタンス変数があるか
        expect(assigns(:group)).to eq group
      end

      it 'redners index' do    #  該当するビューが描画されているか
        expect(response).to render_template :index
      end
    end

    context 'not log in' do    #  ログインしていない場合のテスト
      before do
        get :index, params: { group_id: group.id }
      end

      it 'redirects to new_user_session_path' do    #  意図したビューにリダイレクトできているか
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do    #  メッセージを作成するアクション
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }
    # attributes_forはcreate、build同様FactoryBotによって定義されるメソッドで、オブジェクトを生成せずにハッシュを生成するという特徴があります。

    context 'log in' do    #  ログインしているかつ、
      before do
        login user
      end

      context 'can save' do    #  (ログインしているかつ、)保存に成功した場合
        
        # expectの引数として、subjectを定義して渡しています。
        subject {
          post :create,      # get :indexとかと同じで、post :create（下のparams: paramsも含める）を変数subjectに代入している
          params: params
        }

        it 'count up message' do    #  メッセージの保存はできたのか
          expect{ subject }.to change(Message, :count).by(1)
          # createアクションのテストを行う際にはchangeマッチャを利用することができます。changeマッチャは引数が変化したかどうかを確かめるために利用できるマッチャです。
          # change(Message, :count).by(1)と記述することによって、Messageモデルのレコードの総数が1個増えたかどうかを確かめることができます。保存に成功した際にはレコード数が必ず1個増えるため、このようなテストとなります。
        end

        it 'redirects to group_messages_path' do    #  意図した画面に遷移しているか
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context 'can not save' do    #  (ログインしているが、)保存に失敗した場合
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }
        # invalid_paramsを定義する際に、attributes_for(:message)の引数に、content: nil, image: nilと記述しています。
        # 擬似的にcreateアクションをリクエストする際にinvalid_paramsを引数として渡してあげることによって、意図的にメッセージの保存に失敗する場合を再現することができます。
        
        subject {
          post :create,
          params: invalid_params
        }

        it 'does not count up' do    #  メッセージの保存は行われなかったか
          expect{ subject }.not_to change(Message, :count)
          # Rspecで「〜であること」を期待する場合にはtoを使用しますが、「〜でないこと」を期待する場合にはnot_toを使用できます。
          # not_to change(Message, :count)と記述することによって、「Messageモデルのレコード数が変化しないこと ≒ 保存に失敗したこと」を確かめることができます。
        end

        it 'renders index' do    #  意図したビューが描画されているか
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'not log in' do    #  ログインしていない場合

      it 'redirects to new_user_session_path' do    #  意図した画面にリダイレクトできているか
        post :create, params: params    #  上で定義した変数subjectと同じ意味
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end