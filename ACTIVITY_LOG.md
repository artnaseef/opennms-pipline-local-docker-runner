Fri Jan  6 13:46:00 MST 2023
============================

PURPOSE of this POC:

	- GET pipeline execution of the application cluster in K8S running locally
	- PARITY between the locally-running environment and the one that runs via the PIPELINE (github actions)
	- NOT NECESSARILY using github actions to run the pipeline
	- RUNNING out of a docker container:
		- Push-button startup
		- Clean isolation (to the extent possible) from developer's environment
			* Docker instance likely shared with host
