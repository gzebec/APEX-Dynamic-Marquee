prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.11'
,p_default_workspace_id=>14477791490959140502
,p_default_application_id=>19568
,p_default_id_offset=>106998971903035204
,p_default_owner=>'GZEBEC'
);
end;
/
 
prompt APPLICATION 19568 - Jedni za druge
--
-- Application Export:
--   Application:     19568
--   Name:            Jedni za druge
--   Date and Time:   12:09 Tuesday March 17, 2020
--   Exported By:     GZEBEC@GMAIL.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 714513083790491585
--   Manifest End
--   Version:         20.1.0.00.11
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/com_oracle_apex_dynamic_marquee
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(714513083790491585)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COM.ORACLE.APEX.DYNAMIC_MARQUEE'
,p_display_name=>'Dynamic Marquee'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'#PLUGIN_FILES#dynamic_marquee.js'
,p_css_file_urls=>'#PLUGIN_FILES#dynamic_marquee.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render (',
'    p_region              in apex_plugin.t_region,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_region_render_result',
'is',
'    -- Constants for the columns of our region source query',
'    c_tag_col   constant pls_integer := 1;',
'    c_tag_url   constant pls_integer := 2;',
'',
'    -- attributes of the plug-in',
'    l_max_display_tags     number          := p_region.attribute_01;',
'    l_tag_separator        varchar2(4000)  := p_region.attribute_02;',
'    l_tag_text_color       varchar2(4000)  := p_region.attribute_03;',
'    ',
'    l_no_data_found        varchar2(32767) := p_region.no_data_found_message;',
'',
'    l_valid_data_type_list wwv_flow_global.vc_arr2;',
'    l_column_value_list    apex_plugin_util.t_column_value_list2;',
'    l_printed_records      number := 0;',
'    l_available_records    number := 20;',
'    l_max                  number;',
'    l_min                  number;',
'    l_total                number := 0;',
'    l_cnts                 number;',
'    l_tag                  varchar2(4000);',
'    l_tag_url              varchar2(4000);',
'',
'begin',
'    -- define the valid column data types for the region query',
'    l_valid_data_type_list(c_tag_col)   := apex_plugin_util.c_data_type_varchar2;',
'    l_valid_data_type_list(c_tag_url)   := apex_plugin_util.c_data_type_varchar2;',
'',
'    -- get the data to be displayed',
'    l_column_value_list := apex_plugin_util.get_data2 (',
'                               p_sql_statement  => p_region.source,',
'                               p_min_columns    => 2,',
'                               p_max_columns    => 2,',
'                               p_data_type_list => l_valid_data_type_list,',
'                               p_component_name => p_region.name );',
'',
'   l_available_records := l_column_value_list(c_tag_col).value_list.count;',
'',
'   -----------------------------------------------',
'   -- Determine total count and maximum tag counts',
'   -----------------------------------------------',
'   /*l_max := 0;',
'   l_min := 1000;',
'   FOR i in 1.. l_column_value_list(c_tag_col).value_list.count loop',
'      l_cnts := l_column_value_list(c_tag_col).value_list(i).number_value;',
'      l_total := l_total + l_cnts;',
'      if l_cnts > l_max then',
'         l_max := l_cnts;',
'      end if;',
'      if l_cnts < l_min then',
'         l_min := l_cnts;',
'      end if;',
'   end loop;',
'   if l_max = 0 then l_max := 1; end if;*/',
'',
'   ------------------------',
'   --  Generate marquee  --',
'   ------------------------',
'   ',
'   sys.htp.p(''<div class="marquee">'');',
'   htp.p('' <div class="marquee-text" style="color: '' || l_tag_text_color || ''">'');',
'',
'   for i in 1.. l_column_value_list(c_tag_col).value_list.count loop',
'   ',
'       l_printed_records := l_printed_records + 1;',
'       l_tag := apex_escape.html(l_column_value_list(c_tag_col).value_list(i).varchar2_value);',
'       --l_cnts := l_column_value_list(c_count_col).value_list(i).number_value;',
'       l_tag_url := apex_escape.html(l_column_value_list(c_tag_url).value_list(i).varchar2_value);     ',
'       ',
'       if l_tag_url is not null then',
'           sys.htp.p (''<a href="'' || l_tag_url || ''">'' || l_tag_separator || l_tag || ''</a>'');',
'       else',
'           sys.htp.p (''<span>'' || l_tag_separator || l_tag || ''</span>'');',
'       end if;',
'',
'       if  l_max_display_tags is not null and l_printed_records > l_max_display_tags - 1 then',
'           exit;',
'       end if;',
'   end loop;',
'',
'   sys.htp.p(''  </div>'');',
'   sys.htp.p(''</div>'');',
'',
'   if l_printed_records = 0 then',
'       sys.htp.p(''<span class="nodatafound">''||l_no_data_found||''</span>'');',
'   end if;',
'',
'   return null;',
'end render;'))
,p_api_version=>1
,p_render_function=>'render'
,p_standard_attributes=>'SOURCE_LOCATION:NO_DATA_FOUND_MESSAGE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>Use this region type plug-in to render a marquee tag cloud. Special thanks to <a href="https://www.javainhand.com/2020/03/how-to-add-dynamic-marquee-in-oracle.html", target="_blank"><b>Satish Yadav</b></a></p>'
,p_version_identifier=>'1.0'
,p_about_url=>'https://apex.oracle.com/pls/apex/f?p=99752:1'
,p_files_version=>8
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(755166060278816399)
,p_plugin_id=>wwv_flow_api.id(714513083790491585)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Maximum number of tags'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_display_length=>4
,p_max_length=>4
,p_is_translatable=>false
,p_help_text=>'Enter the maximum number of tags to display.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(756697709035347422)
,p_plugin_id=>wwv_flow_api.id(714513083790491585)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Tag separator'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_display_length=>100
,p_max_length=>100
,p_is_translatable=>false
,p_examples=>'&nbsp;&nbsp;&nbsp;'
,p_help_text=>'Tag separator.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(756858814030358565)
,p_plugin_id=>wwv_flow_api.id(714513083790491585)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Tag color'
,p_attribute_type=>'COLOR'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Set tag color. If not set, tag color is inherit.'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(754303409913770247)
,p_plugin_id=>wwv_flow_api.id(714513083790491585)
,p_name=>'SOURCE_LOCATION'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_depending_on_has_to_exist=>true
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'select tag, url',
'  from your_tag_table',
' order by 1',
'</pre>'))
,p_help_text=>'Set data source.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '406D65646961206F6E6C792073637265656E20616E6420286D61782D77696474683A20363430707829207B0D0A20206469762E6D617271756565207B0D0A20202020666F6E742D73697A653A20312E3572656D3B0D0A2020202070616464696E673A2030';
wwv_flow_api.g_varchar2_table(2) := '3B0D0A20207D0D0A7D0D0A0D0A6469762E6D617271756565207B0D0A202077686974652D73706163653A206E6F2D777261703B0D0A2020666F6E742D73697A653A20322E3572656D3B0D0A202070616464696E673A20313070783B0D0A20206261636B67';
wwv_flow_api.g_varchar2_table(3) := '726F756E643A20696E68657269743B2F2A234535454646383B2A2F0D0A202020206F766572666C6F773A2068696464656E3B0D0A7D0D0A0D0A6469762E6D617271756565203E206469762E6D6172717565652D74657874207B0D0A202077686974652D73';
wwv_flow_api.g_varchar2_table(4) := '706163653A206E6F777261703B0D0A2020646973706C61793A20696E6C696E653B0D0A202077696474683A206175746F3B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(722070180583285135)
,p_plugin_id=>wwv_flow_api.id(714513083790491585)
,p_file_name=>'dynamic_marquee.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '766172206D617271756565203D202428276469762E6D61727175656527293B0D0A76617220676F203D20747275653B0D0A6D6172717565652E686F766572280D0A202066756E6374696F6E2829207B0D0A20202020676F203D2066616C73653B0D0A2020';
wwv_flow_api.g_varchar2_table(2) := '7D2C0D0A202066756E6374696F6E2829207B0D0A20202020676F203D20747275653B0D0A20207D0D0A293B0D0A6D6172717565652E656163682866756E6374696F6E2829207B0D0A2020766172206D6172203D20242874686973292C0D0A20202020696E';
wwv_flow_api.g_varchar2_table(3) := '64656E74203D206D61722E776964746828293B0D0A20206D61722E6D617271756565203D2066756E6374696F6E2829207B0D0A2020202069662028676F29207B0D0A202020202020696E64656E742D2D3B0D0A2020202020206D61722E63737328277465';
wwv_flow_api.g_varchar2_table(4) := '78742D696E64656E74272C20696E64656E74293B0D0A20202020202069662028696E64656E74203C202D31202A206D61722E6368696C6472656E28276469762E6D6172717565652D7465787427292E7769647468282929207B0D0A202020202020202069';
wwv_flow_api.g_varchar2_table(5) := '6E64656E74203D206D61722E776964746828293B0D0A2020202020207D0D0A202020207D3B0D0A20207D0D0A20206D61722E646174612827696E74657276616C272C20736574496E74657276616C286D61722E6D6172717565652C2031303030202F2036';
wwv_flow_api.g_varchar2_table(6) := '3029293B0D0A7D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(722071014497285928)
,p_plugin_id=>wwv_flow_api.id(714513083790491585)
,p_file_name=>'dynamic_marquee.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
