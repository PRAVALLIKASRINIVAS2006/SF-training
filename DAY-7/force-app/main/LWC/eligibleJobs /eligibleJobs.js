import { LightningElement, api } from 'lwc';

import getEligibleJobs
    from '@salesforce/apex/EligibleJobsController.getEligibleJobs';

export default class EligibleJobs extends LightningElement {

    // CGPA received from parent component
    @api cgpa;

    // Jobs returned from Apex
    jobs = [];

    // Error returned from Apex
    error;

    // Loading state
    isLoading = false;

    // Used to detect CGPA changes
    _previousCgpa;


    // Load jobs whenever the CGPA is received or changed
    renderedCallback() {

        if (
            this.cgpa !== undefined &&
            this.cgpa !== null &&
            this.cgpa !== this._previousCgpa
        ) {

            this._previousCgpa = this.cgpa;

            this.loadJobs();
        }
    }


    // Get eligible jobs from Apex
    loadJobs() {

        this.isLoading = true;
        this.error = undefined;

        getEligibleJobs({
            cgpa: Number(this.cgpa)
        })

            .then(result => {

                this.jobs = result;

            })

            .catch(error => {

                this.jobs = [];
                this.error = error;

                console.error(
                    'Error loading eligible jobs:',
                    error
                );

            })

            .finally(() => {

                this.isLoading = false;

            });
    }


    // Used by HTML to determine whether jobs exist
    get hasJobs() {

        return this.jobs.length > 0;
    }


    // Used by HTML to show empty state
    get showEmptyState() {

        return (
            !this.isLoading &&
            !this.error &&
            this.jobs.length === 0
        );
    }


    // JobCard → EligibleJobs
    handleViewDetails(event) {

        const jobId = event.detail.jobId;

        console.log(
            'View Job:',
            jobId
        );

        // Job Details will be implemented next.
    }


    // JobCard → EligibleJobs
    handleApply(event) {

        const jobId = event.detail.jobId;

        console.log(
            'Apply Job:',
            jobId
        );

        // Application creation will be implemented next.
    }
}
