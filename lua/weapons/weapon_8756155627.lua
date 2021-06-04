SWEP.PrintName			= "" 
SWEP.Author			= ""
SWEP.Instructions		= ""
SWEP.Spawnable = false
SWEP.AdminOnly = true
SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/c_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.Primary.ClipSize		= 100000000000000000000000000000000
SWEP.Primary.DefaultClip	= 100000000000000000000000000000000
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= 100000000000000000000000000000000
SWEP.Secondary.DefaultClip	= 100000000000000000000000000000000
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ShootSound = Sound( "weapons/357/357_fire2.wav")

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.5 )	

	self:Weirdshit( "models/humans/charple01.mdl" )
end
 
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + 0.1 )

	self:Weirdshit( "5435w" )
end

function SWEP:Weirdshit( model_file )
	local owner = self:GetOwner()

	if ( not owner:IsValid() ) then return end

	self:EmitSound( self.ShootSound )
 
	if ( CLIENT ) then return end

	local ent = ents.Create( "prop_physics" )

	if ( not ent:IsValid() ) then return end

	ent:SetModel( model_file )

	local aimvec = owner:GetAimVector()
	local pos = aimvec * 16 
	pos:Add( owner:EyePos() ) 
	ent:SetPos( pos )

	ent:SetAngles( owner:EyeAngles() )
	ent:Spawn()
 
	local phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end
 
	aimvec:Mul( 100 )
	aimvec:Add( VectorRand( -10, 10 ) )
	phys:ApplyForceCenter( aimvec )
 
	cleanup.Add( owner, "props", ent )
 
	undo.Create( "Weirdshit" )
	        undo.AddEntity( ent )
		undo.SetPlayer( owner )
	undo.Finish()
end