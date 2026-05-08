defmodule Telegex.TypeTest do
  use ExUnit.Case

  test "attachment fields in struct type" do
    assert Telegex.Type.InputMediaPhoto.__attachments__() == [:media]
    assert Telegex.Type.InputMediaVideo.__attachments__() == [:media, :thumbnail, :cover]
    assert Telegex.Type.InputMediaAnimation.__attachments__() == [:media, :thumbnail]
    assert Telegex.Type.InputMediaAudio.__attachments__() == [:media, :thumbnail]
    assert Telegex.Type.InputMediaDocument.__attachments__() == [:media, :thumbnail]
    # Bot API 10.0 new media types
    assert Telegex.Type.InputMediaLivePhoto.__attachments__() == [:media, :photo]
    assert Telegex.Type.InputMediaSticker.__attachments__() == [:media]
    assert Telegex.Type.InputPaidMediaLivePhoto.__attachments__() == [:media, :photo]
  end

  test "new Bot API 10.0 types are defined" do
    assert Telegex.Type.LivePhoto.__meta__() == :type
    assert Telegex.Type.BotAccessSettings.__meta__() == :type
    assert Telegex.Type.SentGuestMessage.__meta__() == :type
    assert Telegex.Type.AcceptedGiftTypes.__meta__() == :type
    assert Telegex.Type.PaidMediaLivePhoto.__meta__() == :type
    assert Telegex.Type.PollMedia.__meta__() == :type
  end
end
