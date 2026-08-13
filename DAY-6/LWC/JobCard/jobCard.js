import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {

    @api job;

    @api isApplying = false;

    @api applicationSubmitted = false;


    get applyButtonLabel() {

        if (this.isApplying) {
            return 'Processing...';
        }

        if (this.applicationSubmitted) {
            return 'Applied';
        }

        return 'Apply';

    }


    get isApplyDisabled() {

        return (
            this.isApplying ||
            this.applicationSubmitted
        );

    }


    handleViewDetails() {

        console.log(
            'Job selected:',
            this.job.Id
        );

    }


    handleApply() {

        if (
            this.isApplying ||
            this.applicationSubmitted
        ) {

            return;

        }


        const applyEvent = new CustomEvent(
            'apply',
            {
                detail: {
                    jobId: this.job.Id
                }
            }
        );


        this.dispatchEvent(applyEvent);

    }

}
