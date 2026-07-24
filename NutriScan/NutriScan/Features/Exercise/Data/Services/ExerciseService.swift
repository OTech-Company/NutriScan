//
//  ExerciseService.swift
//  NutriScan
//

/// Returns static mock exercises.
/// Replace this implementation with a real network call when the API is ready.
struct ExerciseService {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetchCategories() async throws -> CategoryResponseDTO {
        try await networkService.request(ExerciseEndpoint.getCategories)
    }

    func fetchExercises() async throws -> [ExerciseDTO] {
        [
            ExerciseDTO(
                id: "1",
                name: "Full Body Warm Up",
                equipment: "equipment",
                target: "target",
                category: "Warm Up",
                imageName: "figure.walk",
                instructions: "Stand with your feet shoulder-width apart. Perform slow arm circles, leg swings, and torso rotations to gradually raise your heart rate and loosen your joints before a workout. Repeat each movement 10–15 times."
            ),
            ExerciseDTO(
                id: "2",
                name: "Strength Exercise",
                equipment: "dumbbells",
                target: "full body",
                category: "Strength",
                imageName: "figure.strengthtraining.traditional",
                instructions: "Hold a dumbbell in each hand at shoulder height. Press both weights overhead until your arms are fully extended, then slowly lower them back to the starting position. Keep your core tight throughout the movement. Perform 3 sets of 12 repetitions."
            ),
            ExerciseDTO(
                id: "3",
                name: "Both Side Plank",
                equipment: "body weight",
                target: "core",
                category: "Strength",
                imageName: "figure.core.training",
                instructions: "Start in a standard plank position. Shift your weight onto your right forearm and rotate your body sideways, stacking your feet and raising your left arm toward the ceiling. Hold for 20–30 seconds, then switch sides. Keep your hips lifted throughout."
            ),
            ExerciseDTO(
                id: "4",
                name: "Abs Workout",
                equipment: "body weight",
                target: "abs",
                category: "Core",
                imageName: "figure.core.training",
                instructions: "Lie flat on your back with your knees bent and feet flat on the ground. Place your hands behind your head with your elbows pointing outwards. Engaging your abs, slowly lift your upper body off the ground, curling forward until your torso is at a 45-degree angle. Pause for a moment at the top, then slowly lower your upper body back down to the starting position. Repeat for the desired number of repetitions."
            ),
            ExerciseDTO(
                id: "5",
                name: "Torso and Trap Workout",
                equipment: "resistance band",
                target: "trapezius",
                category: "Strength",
                imageName: "figure.rowing",
                instructions: "Sit upright on a bench or chair with a resistance band looped around your feet. Hold one end in each hand. Pull the band toward your torso, driving your elbows back and squeezing your shoulder blades together. Slowly release and repeat for 3 sets of 15 reps."
            ),
            ExerciseDTO(
                id: "6",
                name: "Lower Back Exercise",
                equipment: "body weight",
                target: "lower back",
                category: "Warm Up",
                imageName: "figure.flexibility",
                instructions: "Lie face down on a mat with your arms extended in front of you. Simultaneously lift your arms, chest, and legs off the ground, squeezing your glutes and lower back muscles. Hold for 2–3 seconds at the top, then slowly lower down. Perform 3 sets of 12 repetitions."
            )
        ]
    }
}
