#import bevy_pbr::mesh_functions::mesh_position_local_to_clip
#import bevy_pbr::mesh_types::Mesh
#import bevy_render::view::View

@group(0) @binding(0)
var<uniform> view: View;

@group(1) @binding(0)
var<uniform> mesh: Mesh;

#ifdef SKINNED
@group(1) @binding(1)
var<uniform> joint_matrices: SkinnedMesh;
#import bevy_pbr::skinning
#endif

// NOTE: Bindings must come before functions that use them!
#import bevy_pbr::mesh_functions::mesh_position_local_to_clip

struct Vertex {
    @location(0) position: vec3<f32>,
#ifdef SKINNED
    @location(4) joint_indices: vec4<u32>,
    @location(5) joint_weights: vec4<f32>,
#endif
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
#ifdef SKINNED
    let model = bevy_pbr::skinning::skin_model(vertex.joint_indices, vertex.joint_weights);
#else
    let model = mesh.model;
#endif

    var out: VertexOutput;
    out.clip_position = mesh_position_local_to_clip(model, vec4(vertex.position, 1.0));
    return out;
}

@fragment
fn fragment() -> @location(0) f32 {
    return 1.0;
}