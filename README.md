# AA assignment 2026

By Sarah Bullough, C23303483, TU984

# Video

[![Demo Video](https://img.youtube.com/vi/vTxgbnPFA_I/0.jpg)](https://www.youtube.com/watch?v=vTxgbnPFA_I)

# Description of the project

This project is an underwater ecosystem aquarium simulation. It simulates a creature lifecycle in which begins with a worm-like larva creature as it crawls along the seabed, eating food that drifts down from above. When a larva has eaten enough food it evolves into a manta ray-like adult that flies freely through the water column. These mantarays lay eggs upon eating enough food, which fall to the ground and hatch into new larva after a period of time, completing the lifecycle.

The player can observe the ecosystem from a free-flying camera and spawn additional food manually via a UI button.

# Instructions for use

- Hold right button to move
- WASD to move the camera
- E / Q to move up and down
- Shift to move faster
- Press the Feed button in the UI to drop a new wave of food
- Press the Toggle Gizmos button to view the gizmos working on the boids
  
# How it works:

The boids in this project use a finite state machine alongside weighted steering behaviours to move and do different things. 

Each creature has a StateMachine node that tracks a current state. Every frame it calls _think() from the current state. States are responsible for toggling which steering behaviours are currently active, and checking transition conditions in _think().

Steering behaviours are used by various behaviour nodes on each creature. Each frame, the creature loops through all active behaviours, and accumulates their force vectors (it wil stop adding the force when the total exceeds max_force). This means the higher weighted forces drive the boid the most. The force is lerped into the creature's velocity for smooth turning.

- Larva states: Wander, Seek (food detected), Avoid (another larva too close)
- Adult states: Wander, Seek (food detected), Avoid (another adult too close) → Lay Egg (after eating 5 food)
- Lifecycle: Larva eats 5 food → evolves into Adult → Adult eats 5 food → lays Egg → Egg falls and hatches after 20 seconds → new Larva
Food spawns as RigidBody3D nodes with low gravity, drifting slowly downward so adults can intercept it in the air and larva can collect what settles on the ground.

# List of classes/assets in the project

| Class/asset | Source |
|-----------|-----------|
| game_manager.gd | Self written |
| camera_controller.gd |Self written |
| egg.gd | From [reference]() |
| state.gd + adultstate.gd | Adapted from [minature roatary phone](https://github.com/skooter500/miniature-rotary-phone) |
| larva_animation.gd + adult_animation.gd | Self written |
| all behaviours and states | Adapted from [minature roatary phone](https://github.com/skooter500/miniature-rotary-phone) |
| steering_behaviour.gd | From [minature roatary phone](https://github.com/skooter500/miniature-rotary-phone) |

# References
- Reynolds, C. (1999). Steering Behaviors for Autonomous Characters
- Godot 4 Documentation
- debug_draw_3d addon

# What I am most proud of in the assignment

I'm most proud of the steering behaviour system. I've never coded something in this way so it was extremely satisfying when I got it to work. Rather than hardcoding movement logic into each creature, I built a system where behaviours are self-contained components that each return a force vector. The state machine then just toggles which behaviours are active as needed. This means adding a new behaviour to any creature is as simple as dropping in a new script. Watching the full lifecycle play out was very rewarding for getting the code right.

# What I learned

I learned a lot through this assignment. Firstly, I haven't used Godot in two years almost, so I was very rusty and it was quite hard at times. Nonetheless, I learned how important it is to design systems for extensibility early. The first version of the code had steering logic scattered directly inside state scripts, which made it messy to change and confusing to use. Refactoring the code using frameworks inspired by Reynolds' original steering paper made everything cleaner and easier to debug. I also learned a lot about Godot-specific quirks — particularly around circular scene dependencies with PackedScene exports, and the difference between create_timer and a proper Timer node for reliability. Procedural animation using sine waves and trail systems was also new to me and something I'd like to explore further, as it's not something I've ever used in other projects on Unity.

# Initial project proposal

My idea for this project is to simulate a species' lifescycle in a XR scene.
Starting as a small bug-like creature that will crawl on the floor, it will seek food until it is ready to evolve into its next life stage.
In the second life stage, it can fly, it will seek other creatures to mate and reproduce, as well as food to live.
After it lays an egg, or after a certain amount of time, it will die.
Then the egg will hatch new bugs and the cycle will continue.

Players will be able to change certain parameters in the environment, such as food availability and how long these creatures live before they die if unsuccessful in reproducing.
Players will also be able to set the floor level and the perimeter of where the creatures can go.
