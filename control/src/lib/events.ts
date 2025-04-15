export class Event {
    name: string;
    data: any;

    constructor(name: string, data: any) {
        this.name = name;
        this.data = data;
    }

    static fromJson(jsonString: string): Event {
        const json = JSON.parse(jsonString);
        return new Event(json[0], json[1]);
    }

    toJson(): string {
        return JSON.stringify([this.name, this.data]);
    }

    toString(): string {
        return `${this.name}: ${this.data}`;
    }
}