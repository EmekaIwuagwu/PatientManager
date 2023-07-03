// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientManager {
    struct Patient {
        uint256 id;
        string firstName;
        string lastName;
        string address;
        string telephoneNumber;
        string emailAddress;
        uint256 dateOfBirth;
        string patientCondition;
        uint256 lastDiagnosticDate;
        string nameOfDoctor;
        bool drugsAdministered;
        uint256 nextAppointmentDate;
    }

    mapping(uint256 => Patient) public patients;
    uint256 public totalPatients;
    address public owner;

    event PatientCreated(uint256 patientId);
    event PatientUpdated(uint256 patientId);
    event PatientDeleted(uint256 patientId);
    event PaymentReceived(address indexed from, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createPatient(
        string memory _firstName,
        string memory _lastName,
        string memory _address,
        string memory _telephoneNumber,
        string memory _emailAddress,
        uint256 _dateOfBirth,
        string memory _patientCondition,
        string memory _nameOfDoctor,
        bool _drugsAdministered,
        uint256 _nextAppointmentDate
    ) external onlyOwner {
        uint256 patientId = totalPatients + 1;
        patients[patientId] = Patient({
            id: patientId,
            firstName: _firstName,
            lastName: _lastName,
            address: _address,
            telephoneNumber: _telephoneNumber,
            emailAddress: _emailAddress,
            dateOfBirth: _dateOfBirth,
            patientCondition: _patientCondition,
            lastDiagnosticDate: block.timestamp,
            nameOfDoctor: _nameOfDoctor,
            drugsAdministered: _drugsAdministered,
            nextAppointmentDate: _nextAppointmentDate
        });

        totalPatients++;
        emit PatientCreated(patientId);
    }

    function deletePatient(uint256 _patientId) external onlyOwner {
        delete patients[_patientId];
        emit PatientDeleted(_patientId);
    }

    function updatePatient(
        uint256 _patientId,
        string memory _firstName,
        string memory _lastName,
        string memory _address,
        string memory _telephoneNumber,
        string memory _emailAddress,
        uint256 _dateOfBirth,
        string memory _patientCondition,
        string memory _nameOfDoctor,
        bool _drugsAdministered,
        uint256 _nextAppointmentDate
    ) external onlyOwner {
        require(_patientId <= totalPatients, "Patient ID does not exist");

        Patient storage patient = patients[_patientId];
        patient.firstName = _firstName;
        patient.lastName = _lastName;
        patient.address = _address;
        patient.telephoneNumber = _telephoneNumber;
        patient.emailAddress = _emailAddress;
        patient.dateOfBirth = _dateOfBirth;
        patient.patientCondition = _patientCondition;
        patient.nameOfDoctor = _nameOfDoctor;
        patient.drugsAdministered = _drugsAdministered;
        patient.nextAppointmentDate = _nextAppointmentDate;

        emit PatientUpdated(_patientId);
    }

    function findPatientById(uint256 _patientId)
        external
        view
        returns (
            uint256,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            uint256,
            string memory,
            bool,
            uint256
        )
    {
        require(_patientId <= totalPatients, "Patient ID does not exist");

        Patient memory patient = patients[_patientId];
        return (
            patient.id,
            patient.firstName,
            patient.lastName,
            patient.address,
            patient.telephoneNumber,
            patient.emailAddress,
            patient.dateOfBirth,
            patient.patientCondition,
            patient.drugsAdministered,
            patient.nextAppointmentDate
        );
    }

    function acceptPayment() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    function returnCoins(address payable _receiver, uint256 _amount) external onlyOwner {
        require(_amount > 0, "Amount must be greater than zero");
        require(address(this).balance >= _amount, "Insufficient contract balance");

        _receiver.transfer(_amount);
    }
}
