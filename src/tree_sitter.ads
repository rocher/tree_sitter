with Ada.Finalization;
with System;

with Tree_Sitter_API; use Tree_Sitter_API;

package Tree_Sitter is

   type Parser is new Ada.Finalization.Limited_Controlled with private;

   overriding
   procedure Initialize (Self : in out Parser);

   overriding
   procedure Finalize (Self : in out Parser);

   type Tree is new Ada.Finalization.Limited_Controlled with private;

   overriding
   procedure Finalize (Self : in out Tree);

   procedure Set_Language (Self : in out Parser; Lang : TSLanguage);

   function Parse_String
     (Self : in out Parser'Class; Content : String) return Tree;

   type Node is private;

   function Root_Node (Self : Tree) return Node;

   function Kind (Self : Node) return String;
   function Child_Count (Self : Node) return Natural;
   function Child (Self : Node; Index : Natural) return Node;

private

   type Parser is new Ada.Finalization.Limited_Controlled with record
      Internal : TSParser := TSParser (System.Null_Address);
   end record;

   type Tree is new Ada.Finalization.Limited_Controlled with record
      Internal : TSTree := TSTree (System.Null_Address);
   end record;

   type Node is record
      Internal : TSNode;
   end record;

end Tree_Sitter;
