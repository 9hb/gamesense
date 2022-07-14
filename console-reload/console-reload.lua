-- -------------- --
-- mady by domcqq --
-- -------------- --

client.set_event_callback(
    "console_input",
    function(text)
        if text:match("rsc") then
            client.reload_active_scripts()
        end
    end
)
