
/**
 * The "EDIT <<$tablename_clean_singular|replace:'_':' '|capitalize>>" form
 * ----------------------------------------------------------------------
 */
function <<$tablename_clean_singular>>_edit($form, &$form_state) {

  # 1 - get the desired id, make sure it seems valid
  $<<$tablename_clean_singular>>_id = get_id_from_form($form_state, '<<$tablename_clean_singular>>_edit');
  if (!<<$tablename_clean_singular>>_id_is_valid($<<$tablename_clean_singular>>_id)) {
    drupal_set_message(t('Attempted to edit an invalid <<$tablename_clean_singular|replace:'_':' '|capitalize>> ID.'));
    watchdog('sleetmute', "UID  " . get_user_id() . " tried to edit an invalid <<$tablename_clean_singular>>_id" );
    drupal_goto('<<$tablename_clean>>');
  }

  # 2 - get the object from the database
  $q = "SELECT * FROM {<<$tablename>>} WHERE id = :id";
  $<<$tablename_clean_singular>> = db_query($q,
                      array(
                            ':id' => $<<$tablename_clean_singular>>_id,
                    ))->fetchObject();

  # FIX - may not want/need all these fields in the form
  # TODO - handle the situation where the user gives us a bad id?
  # 3 - assign the current values for each field
  $<<$tablename_clean_singular>>_id = $<<$tablename_clean_singular>>->id;
<<section name=id loop=$fields>>
  $<<$fields[id]>> = $<<$tablename_clean_singular>>-><<$fields[id]>>;
<</section>>

  # 3 - start the drupal form here
  $form['description'] = array(
    '#type' => 'item',
    '#title' => t('Edit your <<$tablename_clean_singular|replace:'_':' '|capitalize>>'),
  );
  # need a hidden 'id' field for the edit process
  $form['<<$tablename_clean_singular>>_id'] = array(
    '#type' => 'hidden',
    '#value' => $<<$tablename_clean_singular>>->id,
  );
  
  # 5 - include the part of the form that is common to 'add' and 'edit'
  require_once('<<$tablename_clean>>_form.inc');

  return $form;
}

/**
 * the <<$tablename_clean>>/edit form validation function
 */
function <<$tablename_clean_singular>>_edit_validate($form, &$form_state) {
  # stub function
}

/**
 * handle the <<$tablename_clean>>/edit 'submit' process
 */
function <<$tablename_clean_singular>>_edit_submit($form, &$form_state) {
  $<<$tablename_clean_singular>> = new stdClass();
  $<<$tablename_clean_singular>>->id = $form_state['values']['<<$tablename_clean_singular>>_id'];
<<section name=id loop=$fields>>
<<if preg_match('/^id$/', $fields[id]) == 0 >>
  $<<$tablename_clean_singular>>-><<$fields[id]>> = $form_state['values']['<<$fields[id]>>'];
<</if>>
<</section>>

  # FIX - add whatever update conditions you need
  # do the update
  try {
    db_update('<<$tablename>>')
      ->fields(array(
<<section name=id loop=$fields>>
<<if preg_match('/^id$/', $fields[id]) == 0 >>
         '<<$fields[id]>>' => $<<$tablename_clean_singular>>-><<$fields[id]>>,
<</if>>
<</section>>
      ))
      ->condition('id', $<<$tablename_clean_singular>>->id)
      ->execute();
  } catch (Exception $e) {
    drupal_set_message(t("Sorry, a problem happened. Most likely the <<$tablename_clean_singular|replace:'_':' '|capitalize>> name was not unique. ($e)"), 'error');
  }

  # back to the list page
  $form_state['redirect'] = '<<$tablename_clean>>';
}


