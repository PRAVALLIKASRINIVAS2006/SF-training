import { LightningElement } from 'lwc';

import getStudent
    from '@salesforce/apex/StudentProfileController.getStudent';

import updateStudent
    from '@salesforce/apex/StudentProfileController.updateStudent';

export default class StudentProfile extends LightningElement {

    studentId;
    studentName;
    cgpa;

    isLoading = true;
    isSaving = false;

    successMessage = '';
    errorMessage = '';

    connectedCallback() {
        this.loadStudent();
    }

    // Load the Student record
    loadStudent() {

        this.isLoading = true;
        this.errorMessage = '';

        getStudent()
            .then(result => {

                if (result) {

                    this.studentId = result.Id;
                    this.studentName = result.Name;
                    this.cgpa = result.CGPA__c;

                } else {

                    this.errorMessage =
                        'No Student record found for the current user.';

                }

            })
            .catch(error => {

                this.errorMessage =
                    this.getErrorMessage(error);

            })
            .finally(() => {

                this.isLoading = false;

            });
    }

    // Handle CGPA change
    handleCgpaChange(event) {

        this.cgpa = event.target.value;

        // Clear old messages when user edits the value
        this.successMessage = '';
        this.errorMessage = '';
    }

    // Save Student profile
    handleSave() {

        this.successMessage = '';
        this.errorMessage = '';

        // Get the CGPA input
        const input = this.template.querySelector(
            'lightning-input'
        );

        // Client-side validation
        if (!input.reportValidity()) {
            return;
        }

        // Check CGPA range
        if (this.cgpa < 0 || this.cgpa > 10) {

            this.errorMessage =
                'CGPA must be between 0 and 10.';

            return;
        }

        this.isSaving = true;

        updateStudent({
            studentId: this.studentId,
            cgpa: Number(this.cgpa)
        })
            .then(result => {

                // Update local value
                this.cgpa = result.CGPA__c;

                // Show success message
                this.successMessage =
                    'Profile updated successfully.';

                // Tell the parent that the profile was saved
                this.dispatchEvent(
                    new CustomEvent('profilesaved', {
                        detail: {
                            cgpa: result.CGPA__c
                        }
                    })
                );

            })
            .catch(error => {

                this.errorMessage =
                    this.getErrorMessage(error);

            })
            .finally(() => {

                this.isSaving = false;

            });
    }

    // Get readable error message
    getErrorMessage(error) {

        if (
            error &&
            error.body &&
            error.body.message
        ) {

            return error.body.message;

        }

        return 'Something went wrong while updating the profile.';
    }
}
