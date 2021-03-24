local entmeta = FindMetaTable("Entity")

function entmeta:Horde_AddSlow(duration, more)
    timer.Remove("Horde_RemoveSlow" .. self:GetCreationID())
    timer.Create("Horde_RemoveSlow" .. self:GetCreationID(), duration, 1, function ()
        self:Horde_RemoveSlow()
    end)

    self.Horde_Slow = 1
    -- VJ
    if (not self.Horde_StoredAnimationPlaybackRate) then
        if self.AnimationPlaybackRate then
            self.Horde_StoredAnimationPlaybackRate = self.AnimationPlaybackRate
            self.AnimationPlaybackRate = self.Horde_StoredAnimationPlaybackRate * (1 - 0.15 * (1 + more))
        else
            self.Horde_StoredAnimationPlaybackRate = self:GetPlaybackRate()
            self:SetPlaybackRate(self.Horde_StoredAnimationPlaybackRate * (1 - 0.15 * (1 + more)))
        end
    end
end

function entmeta:Horde_RemoveSlow()
    if not self:IsValid() then return end
    self.Horde_Slow = 0
    -- VJ
    if self.Horde_StoredAnimationPlaybackRate then
        self.AnimationPlaybackRate = self.Horde_StoredAnimationPlaybackRate
    else
        self:SetPlaybackRate(self.Horde_StoredAnimationPlaybackRate)
    end
    self.Horde_StoredAnimationPlaybackRate = nil
end

hook.Add("Horde_ResetStatus", "Horde_SlowReset", function(ply)
    ply.Horde_Slow = 0
end)