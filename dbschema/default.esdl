module default {
    scalar type ProjectState extending enum <"initialized", "running", "done", "failed">;

    type Project {
        required name: str;
        required single ref: Reference;
        required multi targets: Genome;
        required state: ProjectState;
        single result: str;
    }
    type Reference {
        required name: str;
        multi link projects := .<ref[is Project];
    }
    type Genome {
        required data: bytes;
        multi link chunks: Chunk;
        multi link projects := .<targets[is Project];
    }
    type Chunk {
        required data: str;
        single result: str;
        single link genome := assert_single(.<chunks[is Genome]);
    }
}
