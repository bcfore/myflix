Fabricator(:queued_user_video) do
  video { Fabricate(:video) }
end
