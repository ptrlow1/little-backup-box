<?php
	$LogFile="${WORKING_DIR}/tmp/little-backup-box.log";

	function popup($MESSAGE,$POPUP_ALLOWED) {
		$MESSAGE=str_replace("\n","\\n",$MESSAGE);
		if ($POPUP_ALLOWED) {
			echo "<script>";
				echo 'alert("' . $MESSAGE . '")';
			echo "</script>";
		}
	}
?>
