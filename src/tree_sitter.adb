with Interfaces.C.Strings;

package body Tree_Sitter is

   use all type System.Address;

   ----------------
   -- Initialize --
   ----------------

   overriding
   procedure Initialize (Self : in out Parser) is
   begin
      Self.Internal := ts_parser_new;
   end Initialize;

   --------------
   -- Finalize --
   --------------

   overriding
   procedure Finalize (Self : in out Parser) is
   begin
      if Self.Internal /= TSParser (System.Null_Address) then
         ts_parser_delete (Self.Internal);
      end if;
   end Finalize;

   --------------
   -- Finalize --
   --------------

   overriding
   procedure Finalize (Self : in out Tree) is
   begin
      if Self.Internal /= TSTree (System.Null_Address) then
         ts_tree_delete (Self.Internal);
      end if;
   end Finalize;

   ------------------
   -- Set_Language --
   ------------------

   procedure Set_Language (Self : in out Parser; Lang : TSLanguage) is
      Success : constant Boolean :=
        Boolean (ts_parser_set_language (Self.Internal, Lang));
   begin
      if not Success then
         raise Program_Error with "Error carregant el llenguatge al parser";
      end if;
   end Set_Language;

   ------------------
   -- Parse_String --
   ------------------

   function Parse_String
     (Self : in out Parser'Class; Content : String) return Tree
   is
      C_Str : Interfaces.C.Strings.chars_ptr :=
        Interfaces.C.Strings.New_String (Content);
   begin
      return Result : Tree do
         Result.Internal :=
           ts_parser_parse_string
             (Self.Internal, TSTree (System.Null_Address), C_Str,
              Content'Length);
         Interfaces.C.Strings.Free (C_Str);
      end return;
   end Parse_String;

   ---------------
   -- Root_Node --
   ---------------

   function Root_Node (Self : Tree) return Node is
   begin
      return Result_Node : Node do
         Result_Node.Internal := ts_tree_root_node (Self.Internal);
      end return;
   end Root_Node;

   ----------
   -- Kind --
   ----------

   function Kind (Self : Node) return String is
   begin
      if System.Address (Self.Internal.Tree) = System.Null_Address then
         return "NODE_INVALID_NULL_TREE";
      end if;
      return Interfaces.C.Strings.Value (ts_node_type (Self.Internal));
   end Kind;

   -----------------
   -- Child_Count --
   -----------------

   function Child_Count (Self : Node) return Natural is
      Count : Interfaces.C.unsigned := 0;
   begin
      Count := ts_node_child_count (Self.Internal);
      return Natural (Count);
   end Child_Count;

   -----------
   -- Child --
   -----------

   function Child (Self : Node; Index : Natural) return Node is
   begin
      return Result_Node : Node do
         Result_Node.Internal :=
           ts_node_child (Self.Internal, Interfaces.C.unsigned (Index));
      end return;
   end Child;

end Tree_Sitter;
