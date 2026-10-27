with Interfaces.C.Extensions;
with Interfaces.C.Strings;
with System;

package Tree_Sitter_API is

   type TSParser is new System.Address;
   type TSTree is new System.Address;
   type TSLanguage is new System.Address;

   type uint32_array is array (0 .. 3) of Interfaces.C.unsigned;
   for uint32_array'Component_Size use 32;

   type TSNode is record
      Context : uint32_array;        -- uint32_t context[4]
      Id      : System.Address;      -- const void *id
      Tree    : TSTree;              -- const TSTree *tree
   end record;
   pragma Convention (C_Pass_By_Copy, TSNode);
   pragma Assert (TSNode'Size = 256);

   type TSPoint is record
      Row    : Interfaces.C.unsigned;
      Column : Interfaces.C.unsigned;
   end record;
   pragma Convention (C, TSPoint);

   type TSRange is record
      Start_Point : TSPoint;
      End_Point   : TSPoint;
      Start_Byte  : Interfaces.C.unsigned;
      End_Byte    : Interfaces.C.unsigned;
   end record;
   pragma Convention (C, TSRange);

   function ts_parser_new return TSParser
   with Import, Convention => C, External_Name => "ts_parser_new";

   procedure ts_parser_delete (Self : TSParser)
   with Import, Convention => C, External_Name => "ts_parser_delete";

   function ts_parser_set_language
     (Self : TSParser; Language : TSLanguage)
      return Interfaces.C.Extensions.bool
   with Import, Convention => C, External_Name => "ts_parser_set_language";

   function ts_parser_parse_string
     (Self        : TSParser;
      Old_Tree    : TSTree;
      String_Data : Interfaces.C.Strings.chars_ptr;
      Length      : Interfaces.C.unsigned) return TSTree
   with Import, Convention => C, External_Name => "ts_parser_parse_string";

   procedure ts_tree_delete (Self : TSTree)
   with Import, Convention => C, External_Name => "ts_tree_delete";

   function ts_tree_root_node (Self : TSTree) return TSNode
   with Import, Convention => C, External_Name => "ts_tree_root_node";

   function ts_node_type (Self : TSNode) return Interfaces.C.Strings.chars_ptr
   with Import, Convention => C, External_Name => "ts_node_type";

   function ts_node_child_count (Self : TSNode) return Interfaces.C.unsigned
   with Import, Convention => C, External_Name => "ts_node_child_count";

   function ts_node_child
     (Self : TSNode; Index : Interfaces.C.unsigned) return TSNode
   with Import, Convention => C, External_Name => "ts_node_child";

end Tree_Sitter_API;
