import { LightningElement } from 'lwc';

import getEligibleJobs
    from '@salesforce/apex/ApplicationController.getEligibleJobs';

import submitApplication
    from '@salesforce/apex/ApplicationController.submitApplication';

export default class EligibleJobs extends LightningElement {

    // ==========================================
    // Jobs
    // ==========================================

    jobs = [];


    // ==========================================
    // Loading
    // ==========================================

    isLoading = false;


    // ==========================================
    // Error
    // ==========================================

    hasError = false;

    errorMessage = '';


    // ==========================================
    // Success
    // ==========================================

    showSuccessMessage = false;

    successMessage = '';


    // ==========================================
    // Load Component
    // ==========================================

    connectedCallback() {

        this.loadJobs();

    }


    // ==========================================
    // Get Eligible Jobs
    // ==========================================

    async loadJobs() {

        this.isLoading = true;

        this.hasError = false;

        this.errorMessage = '';


        try {

            const result = await getEligibleJobs();

            this.jobs = (result || []).map(job => {

                return {
                    ...job,
                    isApplying: false,
                    applicationSubmitted: false
                };

            });

        } catch (error) {

            this.jobs = [];

            this.hasError = true;

            this.errorMessage =
                this.getErrorMessage(error);

        } finally {

            this.isLoading = false;

        }

    }


    // ==========================================
    // Show Jobs
    // ==========================================

    get showJobs() {

        return (
            !this.isLoading &&
            !this.hasError &&
            this.jobs.length > 0
        );

    }


    // ==========================================
    // Empty State
    // ==========================================

    get showEmptyState() {

        return (
            !this.isLoading &&
            !this.hasError &&
            this.jobs.length === 0
        );

    }


    // ==========================================
    // Apply
    // ==========================================

    async handleApply(event) {

        const jobId = event.detail.jobId;


        // Prevent another application while
        // one is already being processed
        if (this.jobs.some(job => job.isApplying)) {

            return;

        }


        // --------------------------------------
        // Set Processing State
        // --------------------------------------

        this.jobs = this.jobs.map(job => {

            if (job.Id === jobId) {

                return {
                    ...job,
                    isApplying: true
                };

            }

            return job;

        });


        this.showSuccessMessage = false;

        this.hasError = false;


        try {

            // ----------------------------------
            // Call Apex
            // ----------------------------------

            const applicationId =
                await submitApplication({
                    jobId: jobId
                });


            console.log(
                'Application created:',
                applicationId
            );


            // ----------------------------------
            // Success State
            // ----------------------------------

            this.jobs = this.jobs.map(job => {

                if (job.Id === jobId) {

                    return {
                        ...job,
                        isApplying: false,
                        applicationSubmitted: true
                    };

                }

                return job;

            });


            this.successMessage =
                'Application submitted successfully.';

            this.showSuccessMessage = true;


        } catch (error) {

            // ----------------------------------
            // Failure State
            // ----------------------------------

            this.jobs = this.jobs.map(job => {

                if (job.Id === jobId) {

                    return {
                        ...job,
                        isApplying: false
                    };

                }

                return job;

            });


            this.hasError = true;

            this.errorMessage =
                this.getErrorMessage(error);

        }

    }


    // ==========================================
    // Error Message
    // ==========================================

    getErrorMessage(error) {

        if (
            error &&
            error.body &&
            error.body.message
        ) {

            return error.body.message;

        }


        if (
            error &&
            error.message
        ) {

            return error.message;

        }


        return 'Something went wrong. Please try again.';

    }

}
