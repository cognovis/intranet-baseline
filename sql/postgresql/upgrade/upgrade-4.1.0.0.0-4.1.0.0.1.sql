-- upgrade-4.1.0.0.0-4.1.0.0.1.sql
SELECT acs_log__debug('/packages/intranet-baseline/sql/postgresql/upgrade/upgrade-4.1.0.0.0-4.1.0.0.1.sql','');



create or replace function inline_0 () 
returns integer as $body$
DECLARE
	v_count			integer;
BEGIN
	-- Check that template_p exists in the database
	select	count(*) into v_count 
	from	user_tab_columns 
	where	lower(table_name) = 'im_projects_audit' and
		lower(column_name) = 'baseline_id';
	IF v_count > 0  THEN return 1; END IF; 

		alter table im_projects_audit
		add baseline_id integer
		constraint im_projects_audit_baseline_fk
		references im_baselines;
		
		-- Speedup lookup for baselines
		create index im_projects_audit_baselines_idx on im_projects_audit(baseline_id);

	return 0;
END;$body$ language 'plpgsql';
SELECT inline_0 ();
DROP FUNCTION inline_0 ();

