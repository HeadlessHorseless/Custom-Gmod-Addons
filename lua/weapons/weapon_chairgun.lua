SWEP.PrintName			= "Chair Thrower" 
SWEP.Author			= "Headless Horseless Horseman"
SWEP.Instructions		= "LMB to fire an office chair (requires CSS) RMB to shoot a wooden chair (does not require anything)"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.ShootSound = Sound( "Metal.SawbladeStick" )

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.5 )	

	self:ThrowChair( "models/props/cs_office/Chair_office.mdl" )
end
 
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + 0.1 )

	self:ThrowChair( "models/props_c17/FurnitureChair001a.mdl" )
end

function SWEP:ThrowChair( model_file )
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
 
	undo.Create( "Thrown_Chair" )
	        undo.AddEntity( ent )
		undo.SetPlayer( owner )
	undo.Finish()
end