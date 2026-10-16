import SwiftUI

struct ContentView: View {

    // Part B – state variables
    @State private var students: [Student] = []
    @State private var studentName = ""
    @State private var markText = ""
    @State private var errorMessage = ""

    // Part G – passed student count
    private var passedCount: Int {
        students.filter { $0.passed }.count
    }

    var body: some View {

        NavigationStack {

            VStack(spacing: 12) {

                // Part C – input interface
                VStack(alignment: .leading, spacing: 10) {

                    Text("Student Name")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("Student Name", text: $studentName)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)

                    Text("Mark")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    TextField("Mark (0–100)", text: $markText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)

                    if !errorMessage.isEmpty {
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }

                    Button {
                        addStudent()
                    } label: {
                        Label("Add Student", systemImage: "person.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                // Part G – passed count display
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                    Text("Passed Students: \(passedCount)")
                        .font(.headline)
                    Spacer()
                    Text("Total: \(students.count)")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // Part E – student list
                List(students) { student in

                    // Part F – navigation to detail screen
                    NavigationLink {
                        StudentDetailView(student: student)
                    } label: {
                        StudentRow(student: student)
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if students.isEmpty {
                        ContentUnavailableView(
                            "No Students Yet",
                            systemImage: "person.3",
                            description: Text("Add a student above.")
                        )
                    }
                }
            }
            .padding(.top)
            .navigationTitle("SE4041 Marks")
        }
    }

    // Part D – add a student with validation
    private func addStudent() {

        let name = studentName.trimmingCharacters(in: .whitespaces)

        guard !name.isEmpty else {
            errorMessage = "Please enter a student name."
            return
        }

        guard let mark = Int(markText.trimmingCharacters(in: .whitespaces)) else {
            errorMessage = "Mark must be a whole number."
            return
        }

        guard mark >= 0 && mark <= 100 else {
            errorMessage = "Mark must be between 0 and 100."
            return
        }

        students.append(Student(name: name, mark: mark))

        studentName = ""
        markText = ""
        errorMessage = ""
    }
}

// Reusable subview for a list row
struct StudentRow: View {

    let student: Student

    var body: some View {
        HStack {
            Image(systemName: student.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(student.passed ? .green : .red)

            Text(student.name)

            Spacer()

            // Text + colour, so result doesn't rely on colour alone
            Text("\(student.mark)")
                .bold()
                .foregroundStyle(student.passed ? .green : .red)

            Text(student.passed ? "Pass" : "Fail")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
