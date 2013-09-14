{*
TestLink Open Source Project - http://testlink.sourceforge.net/
$Id: projectView.tpl,v 1.23 2010/10/17 09:46:37 franciscom Exp $
Purpose: smarty template - edit / delete Test Plan

Development hint:
some variables smarty and javascript are created on the inc_*.tpl files.

@internal revisions
@since 1.9.9
20130914 - franciscom - TICKET 5907: Links are not click-able in Description fields for Projects Test Plans and Builds

*}
{assign var="cfg_section" value=$smarty.template|basename|replace:".tpl":""}
{config_load file="input_dimensions.conf" section=$cfg_section}

{* Configure Actions *}
{assign var="managerURL" value="lib/project/projectEdit.php"}
{assign var="deleteAction" value="$managerURL?doAction=doDelete&tprojectID="}
{assign var="editAction" value="$managerURL?doAction=edit&amp;tprojectID="}
{assign var="createAction" value="$managerURL?doAction=create"}

{lang_get s='popup_product_delete' var="warning_msg"}
{lang_get s='delete' var="del_msgbox_title"}

{lang_get var="labels" 
          s='title_testproject_management,testproject_txt_empty_list,tcase_id_prefix,
          th_name,th_notes,testproject_alt_edit,testproject_alt_active,
          th_requirement_feature,testproject_alt_delete,btn_create,public,
          testproject_alt_requirement_feature,th_active,th_delete,th_id,
          th_issuetracker,th_reqmgrsystem_short,active_click_to_change,inactive_click_to_change'}


{include file="inc_head.tpl" openHead="yes" enableTableSorting="yes"}
{include file="inc_del_onclick.tpl"}

<script type="text/javascript">
/* All this stuff is needed for logic contained in inc_del_onclick.tpl */
var del_action=fRoot+'{$deleteAction}';
</script>
</head>

<body {$body_onload}>

<h1 class="title">{$labels.title_testproject_management}</h1>
<div class="workBack">

{if $gui->canManage}
<div class="groupBtn">
  <form method="post" action="{$createAction}">
    <input type="submit" name="create" value="{$labels.btn_create}" />
  </form>
</div>
{/if}

<div id="testproject_management_list">
{if $gui->tprojects == ''}
  {$labels.testproject_txt_empty_list}
{else}
  <form method="post" id="testProjectView" name="testProjectView" action="{$managerURL}">
    <input type="hidden" name="doAction" id="doAction" value="">
    <input type="hidden" name="tprojectID" id="tprojectID" value="">

  <table id="item_view" class="simple_tableruler sortable">
    <tr>
      <th>{$tlImages.toggle_api_info}{$tlImages.sort_hint}{$labels.th_name}</th>
      <th class="{$noSortableColumnClass}">{$labels.th_notes}</th>
      <th>{$tlImages.sort_hint}{$labels.tcase_id_prefix}</th>
      <th>{$tlImages.sort_hint}{$labels.th_issuetracker}</th>
      {* <th>{$tlImages.sort_hint}{$labels.th_reqmgrsystem_short}</th> *}
      <th class="{$noSortableColumnClass}">{$labels.th_requirement_feature}</th>
      <th class="icon_cell">{$labels.th_active}</th>
      <th class="icon_cell">{$labels.public}</th>
      {if $gui->canManage == "yes"}
      <th class="icon_cell">{$labels.th_delete}</th>
      {/if}
    </tr>
    {foreach item=testproject from=$gui->tprojects}
    <tr>
      <td><span class="api_info" style='display:none'>{$tlCfg->api->id_format|replace:"%s":$testproject.id}</span>
          <a href="{$editAction}{$testproject.id}">
             {$testproject.name|escape}
             {if $gsmarty_gui->show_icon_edit}
                  <img title="{$labels.testproject_alt_edit}" alt="{$labels.testproject_alt_edit}"
                       src="{$tlImages.edit}"/>
              {/if}
           </a>
      </td>
      <td>
        {$testproject.notes}
      </td>
      <td width="10%">
        {$testproject.prefix|escape}
      </td>
      
      <td width="10%">
        {$testproject.itstatusImg} &nbsp; {$testproject.itname|escape} 
      </td>
      {*
      <td width="10%">
        {$testproject.rmsstatusImg} &nbsp; {$testproject.rmsname|escape} 
      </td>
      *}
      <td class="clickable_icon">
        {if $testproject.opt->requirementsEnabled}
            <img style="border:none" title="{$labels.testproject_alt_requirement_feature}"
                      alt="{$labels.testproject_alt_requirement_feature}" src="{$tlImages.checked}"/>
          {else}
            &nbsp;
          {/if}
      </td>
      <td class="clickable_icon">
        {if $testproject.active}
            <input type="image" style="border:none" 
                   title="{$labels.active_click_to_change}"  alt="{$labels.active_click_to_change}" 
                   onClick = "doAction.value='setInactive';tprojectID.value={$testproject.id};"
                   src="{$tlImages.on}"/>
          {else}
            <input type="image" style="border:none" 
                   title="{$labels.inactive_click_to_change}"  alt="{$labels.inactive_click_to_change}" 
                   onClick = "doAction.value='setActive';tprojectID.value={$testproject.id};"
                   src="{$tlImages.off}"/>
          {/if}
      </td>
      <td class="clickable_icon">
        {if $testproject.is_public}
            <img style="border:none"  title="{$labels.public}" alt="{$labels.public}" src="{$tlImages.checked}" />
          {else}
            &nbsp;
          {/if}
      </td>
      {if $gui->canManage == "yes"}
      <td class="clickable_icon">
          <img style="border:none;cursor: pointer;"  alt="{$labels.testproject_alt_delete}"
               title="{$labels.testproject_alt_delete}"
               onclick="delete_confirmation({$testproject.id},'{$testproject.name|escape:'javascript'|escape}',
                                          '{$del_msgbox_title}','{$warning_msg}');"
               src="{$tlImages.delete}"/>
      </td>
      {/if}
    </tr>
    {/foreach}

  </table>

{/if}
</div>

</div>

{if $gui->doAction == "reloadAll"}
  <script type="text/javascript">
  top.location = top.location;
  </script>
{else}
  {if $gui->doAction == "reloadNavBar"}
  <script type="text/javascript">
  // remove query string to avoid reload of home page,
  // instead of reload only navbar
  var href_pieces=parent.titlebar.location.href.split('?');
  parent.titlebar.location=href_pieces[0];
  </script>
  {/if}
{/if}

</body>
</html>