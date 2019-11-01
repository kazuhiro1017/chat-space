json.(@message, :content, :image)         # json.content @message.content
                                          # json.image @message.image.url をまとめた1文
json.name @message.user.name
json.date @message.created_at.strftime("%Y/%m/%d (%a) %H:%M")

json.id @message.id